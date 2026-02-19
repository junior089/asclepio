import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/supabase_service.dart';

class AppProvider extends ChangeNotifier {
  // ═══════════════════════════════════════════════════════════════════════════
  // USUÁRIO
  // ═══════════════════════════════════════════════════════════════════════════
  String userName = 'Usuário';
  int userAge = 25;
  double userWeight = 70.0;
  double userHeight = 175.0;
  String userGender = 'Masculino';
  String userAvatar = '';
  String bloodType = 'O+';
  String preExistingConditions = '';
  String userGoal = 'Saúde geral';

  // Computed
  String get selectedAvatar => userAvatar;
  int get stepGoal => stepsGoal;
  double get bmi {
    final hm = userHeight / 100;
    return hm > 0 ? userWeight / (hm * hm) : 0;
  }

  String get bloodPressure => '$systolic/$diastolic';
  double get bodyTemperature => bodyTemp;

  // ═══════════════════════════════════════════════════════════════════════════
  // SINAIS VITAIS
  // ═══════════════════════════════════════════════════════════════════════════
  int heartRate = 72;
  double bodyTemp = 36.5;
  int systolic = 120;
  int diastolic = 80;

  // ═══════════════════════════════════════════════════════════════════════════
  // ATIVIDADE DIÁRIA
  // ═══════════════════════════════════════════════════════════════════════════
  double steps = 0;
  double distance = 0;
  double activeCalories = 0;
  double activityMinutes = 0;
  int moveMinutesGoal = 30;
  int stepsGoal = 8000;
  int caloriesGoal = 500;

  // ═══════════════════════════════════════════════════════════════════════════
  // ÁGUA
  // ═══════════════════════════════════════════════════════════════════════════
  double waterConsumed = 0;
  double dailyWaterGoal = 0;
  List<Map<String, dynamic>> waterConsumptionLog = [];
  String _lastWaterResetDate = '';

  // ═══════════════════════════════════════════════════════════════════════════
  // HISTÓRICOS
  // ═══════════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> weightHistory = [];
  List<Map<String, dynamic>> symptomsHistory = [];
  List<Map<String, dynamic>> exerciseHistory = [];
  List<Map<String, dynamic>> gymHistory = [];
  List<Map<String, dynamic>> cardioHistory = [];

  // ═══════════════════════════════════════════════════════════════════════════
  // MUSCULAÇÃO — PLANO SEMANAL
  // ═══════════════════════════════════════════════════════════════════════════
  Map<int, String> weeklyPlan = {
    0: 'Peito + Tríceps',
    1: 'Costas + Bíceps',
    2: 'Pernas',
    3: 'Ombros + Trapézio',
    4: 'Braços',
    5: 'Full Body',
    6: 'Descanso',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════
  AppProvider() {
    _loadLocal();
  }

  /// Carrega dados locais (SharedPreferences) como fallback.
  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('userName') ?? 'Usuário';
    userAge = prefs.getInt('userAge') ?? 25;
    userWeight = prefs.getDouble('userWeight') ?? 70.0;
    userHeight = prefs.getDouble('userHeight') ?? 175.0;
    userGender = prefs.getString('userGender') ?? 'Masculino';
    userAvatar = prefs.getString('userAvatar') ?? '';
    bloodType = prefs.getString('bloodType') ?? 'O+';
    preExistingConditions = prefs.getString('preExistingConditions') ?? '';
    userGoal = prefs.getString('userGoal') ?? 'Saúde geral';

    heartRate = prefs.getInt('heartRate') ?? 72;
    bodyTemp = prefs.getDouble('bodyTemp') ?? 36.5;
    systolic = prefs.getInt('systolic') ?? 120;
    diastolic = prefs.getInt('diastolic') ?? 80;

    stepsGoal = prefs.getInt('stepsGoal') ?? 8000;
    caloriesGoal = prefs.getInt('caloriesGoal') ?? 500;
    moveMinutesGoal = prefs.getInt('moveMinutesGoal') ?? 30;

    // Água — reset diário
    dailyWaterGoal = userWeight * 35;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _lastWaterResetDate = prefs.getString('lastWaterResetDate') ?? '';
    if (_lastWaterResetDate != today) {
      waterConsumed = 0;
      waterConsumptionLog = [];
      _lastWaterResetDate = today;
      prefs.setString('lastWaterResetDate', today);
      prefs.setDouble('waterConsumed', 0);
      prefs.setString('waterLog', '[]');
    } else {
      waterConsumed = prefs.getDouble('waterConsumed') ?? 0;
      waterConsumptionLog = _decodeList(prefs.getString('waterLog'));
    }

    weightHistory = _decodeList(prefs.getString('weightHistory'));
    symptomsHistory = _decodeList(prefs.getString('symptomsHistory'));
    exerciseHistory = _decodeList(prefs.getString('exerciseHistory'));
    gymHistory = _decodeList(prefs.getString('gymHistory'));
    cardioHistory = _decodeList(prefs.getString('cardioHistory'));

    try {
      final planJson = prefs.getString('weeklyPlan');
      if (planJson != null) {
        final decoded = jsonDecode(planJson) as Map<String, dynamic>;
        weeklyPlan =
            decoded.map((k, v) => MapEntry(int.parse(k), v.toString()));
      }
    } catch (_) {}

    notifyListeners();
  }

  /// Carrega dados do Supabase (chamado após login).
  Future<void> loadFromSupabase() async {
    final svc = SupabaseService.instance;
    final profile = await svc.loadProfile();
    if (profile != null) {
      userName = profile['name'] ?? userName;
      userAge = profile['age'] ?? userAge;
      userWeight = (profile['weight'] as num?)?.toDouble() ?? userWeight;
      userHeight = (profile['height'] as num?)?.toDouble() ?? userHeight;
      userGender = profile['gender'] ?? userGender;
      bloodType = profile['blood_type'] ?? bloodType;
      preExistingConditions =
          profile['pre_existing_conditions'] ?? preExistingConditions;
      userGoal = profile['goal'] ?? userGoal;
      userAvatar = profile['avatar_url'] ?? userAvatar;
      stepsGoal = profile['steps_goal'] ?? stepsGoal;
      caloriesGoal = profile['calories_goal'] ?? caloriesGoal;
      moveMinutesGoal = profile['activity_minutes_goal'] ?? moveMinutesGoal;
      dailyWaterGoal = userWeight * 35;
    }

    final gymData = await svc.loadWorkouts();
    gymHistory = gymData
        .map((e) => {
              'muscleGroup': e['muscle_group'],
              'exercises': e[
                  'exercises'], // JSONB already parsed? Supabase client usually parses it if it's JSON
              'durationMinutes': e['duration_minutes'],
              'totalVolume': e['total_volume'],
              'date': e['created_at'],
            })
        .toList();

    final cardioData = await svc.loadCardio();
    cardioHistory = cardioData
        .map((e) => {
              'type': e['activity_type'],
              'durationSeconds': e['duration_seconds'],
              'distance': (e['distance_km'] as num).toDouble(),
              'pace': (e['pace'] as num).toDouble(),
              'calories': e['calories'],
              'date': e['created_at'],
            })
        .toList();

    final wh = await svc.loadWeightHistory();
    if (wh.isNotEmpty) {
      weightHistory = wh
          .map((e) => {
                'weight': e['weight'],
                'date': e['recorded_at'],
              })
          .toList();
    }

    final plan = await svc.loadWeeklyPlan();
    if (plan != null && plan['plan'] != null) {
      final decoded = plan['plan'] as Map<String, dynamic>;
      // Ensure keys are sorted? No need generally
      weeklyPlan = decoded.map((k, v) => MapEntry(int.parse(k), v.toString()));
    }

    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> _decodeList(String? json) {
    if (json == null) return [];
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(json));
    } catch (_) {
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS — PERFIL
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> updateProfile({
    String? name,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? avatar,
    int? goal,
    String? blood,
    String? conditions,
    String? objective,
  }) async {
    if (name != null) userName = name;
    if (age != null) userAge = age;
    if (weight != null) {
      userWeight = weight;
      dailyWaterGoal = weight * 35;
    }
    if (height != null) userHeight = height;
    if (gender != null) userGender = gender;
    if (avatar != null) userAvatar = avatar;
    if (goal != null) stepsGoal = goal;
    if (blood != null) bloodType = blood;
    if (conditions != null) preExistingConditions = conditions;
    if (objective != null) userGoal = objective;

    // Local
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
    prefs.setInt('userAge', userAge);
    prefs.setDouble('userWeight', userWeight);
    prefs.setDouble('userHeight', userHeight);
    prefs.setString('userGender', userGender);
    prefs.setString('userAvatar', userAvatar);
    prefs.setString('bloodType', bloodType);
    prefs.setString('preExistingConditions', preExistingConditions);
    prefs.setString('userGoal', userGoal);
    prefs.setInt('stepsGoal', stepsGoal);

    // Supabase
    SupabaseService.instance.saveProfile({
      'name': userName,
      'age': userAge,
      'weight': userWeight,
      'height': userHeight,
      'gender': userGender,
      'blood_type': bloodType,
      'goal': userGoal,
      'pre_existing_conditions': preExistingConditions,
      'avatar_url': userAvatar,
      'steps_goal': stepsGoal,
      'calories_goal': caloriesGoal,
      'activity_minutes_goal': moveMinutesGoal,
    });

    notifyListeners();
  }

  Future<void> updateVitals({int? hr, double? temp, int? sys, int? dia}) async {
    if (hr != null) heartRate = hr;
    if (temp != null) bodyTemp = temp;
    if (sys != null) systolic = sys;
    if (dia != null) diastolic = dia;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('heartRate', heartRate);
    prefs.setDouble('bodyTemp', bodyTemp);
    prefs.setInt('systolic', systolic);
    prefs.setInt('diastolic', diastolic);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÁGUA
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> addWater(double amount) async {
    waterConsumed += amount;
    waterConsumptionLog.add({
      'amount': amount,
      'time': DateTime.now().toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('waterConsumed', waterConsumed);
    prefs.setString('waterLog', jsonEncode(waterConsumptionLog));

    SupabaseService.instance.saveWaterEntry({
      'amount_ml': amount.toInt(),
    });
    notifyListeners();
  }

  Future<void> removeWater(int index) async {
    if (index < 0 || index >= waterConsumptionLog.length) return;
    final amount = (waterConsumptionLog[index]['amount'] as num).toDouble();
    waterConsumed = (waterConsumed - amount).clamp(0, double.infinity);
    waterConsumptionLog.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('waterConsumed', waterConsumed);
    prefs.setString('waterLog', jsonEncode(waterConsumptionLog));
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PESO
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> addWeightEntry(double weight) async {
    weightHistory
        .add({'weight': weight, 'date': DateTime.now().toIso8601String()});
    userWeight = weight;
    dailyWaterGoal = weight * 35;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('userWeight', userWeight);
    prefs.setString('weightHistory', jsonEncode(weightHistory));

    SupabaseService.instance.saveWeightEntry(weight);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SINTOMAS
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> addSymptom(String symptom) async {
    symptomsHistory
        .add({'symptom': symptom, 'date': DateTime.now().toIso8601String()});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('symptomsHistory', jsonEncode(symptomsHistory));
    notifyListeners();
  }

  Future<void> removeSymptom(int index) async {
    if (index < 0 || index >= symptomsHistory.length) return;
    symptomsHistory.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('symptomsHistory', jsonEncode(symptomsHistory));
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXERCÍCIOS GERAIS
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> addExercise(Map<String, dynamic> exercise) async {
    exerciseHistory.add(exercise);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('exerciseHistory', jsonEncode(exerciseHistory));
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MUSCULAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════
  String getTodayWorkout() {
    final weekday = DateTime.now().weekday - 1;
    return weeklyPlan[weekday] ?? 'Descanso';
  }

  Future<void> setWeeklyPlan(Map<int, String> plan) async {
    weeklyPlan = plan;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weeklyPlan',
        jsonEncode(plan.map((k, v) => MapEntry(k.toString(), v))));

    SupabaseService.instance.saveWeeklyPlan(
      plan.map((k, v) => MapEntry(k.toString(), v)),
    );
    notifyListeners();
  }

  Future<void> updateWeeklyPlan(int day, String value) async {
    weeklyPlan[day] = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weeklyPlan',
        jsonEncode(weeklyPlan.map((k, v) => MapEntry(k.toString(), v))));
    SupabaseService.instance.saveWeeklyPlan(
      weeklyPlan.map((k, v) => MapEntry(k.toString(), v)),
    );
    notifyListeners();
  }

  Future<void> addGymWorkout(
      String muscleGroup,
      List<Map<String, dynamic>> exercises,
      int durationMinutes,
      double totalVolume) async {
    final workout = {
      'muscleGroup': muscleGroup,
      'exercises': exercises,
      'durationMinutes': durationMinutes,
      'totalVolume': totalVolume,
      'date': DateTime.now().toIso8601String(),
    };
    gymHistory.insert(0, workout);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gymHistory', jsonEncode(gymHistory));

    SupabaseService.instance.saveWorkout({
      'muscle_group': muscleGroup,
      'exercises': exercises,
      'duration_minutes': durationMinutes,
      'total_volume': totalVolume,
    });
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CARDIO
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> addCardioActivity(Map<String, dynamic> activity) async {
    cardioHistory.insert(0, activity);

    final dur = (activity['durationMinutes'] as num?)?.toDouble() ?? 0;
    final cal = (activity['calories'] as num?)?.toDouble() ?? 0;
    final dist = (activity['distance'] as num?)?.toDouble() ?? 0;
    activityMinutes += dur;
    activeCalories += cal;
    distance += dist;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cardioHistory', jsonEncode(cardioHistory));

    SupabaseService.instance.saveCardio({
      'activity_type': activity['type'] ?? '',
      'duration_seconds': activity['durationSeconds'] ?? 0,
      'distance_km': activity['distance'] ?? 0,
      'pace': activity['pace'] ?? 0,
      'calories': activity['calories'] ?? 0,
    });
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSOS
  // ═══════════════════════════════════════════════════════════════════════════
  void updateSteps(double newSteps) {
    steps = newSteps;
    distance = (steps * 0.0007);
    notifyListeners();
  }

  void updateCalories(double cal) {
    activeCalories = cal;
    notifyListeners();
  }
}
