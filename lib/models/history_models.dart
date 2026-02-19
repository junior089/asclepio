
class GymWorkoutRecord {
  final String muscleGroup;
  final int durationMinutes;
  final int totalVolume;
  final List<ExerciseSetRecord> exercises;
  final DateTime date;

  const GymWorkoutRecord({
    required this.muscleGroup,
    required this.durationMinutes,
    required this.totalVolume,
    required this.exercises,
    required this.date,
  });

  factory GymWorkoutRecord.fromMap(Map<String, dynamic> map) {
    return GymWorkoutRecord(
      muscleGroup: map['muscleGroup'] as String? ?? '',
      durationMinutes: map['durationMinutes'] as int? ?? 0,
      totalVolume: map['totalVolume'] as int? ?? 0,
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseSetRecord.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'muscleGroup': muscleGroup,
        'durationMinutes': durationMinutes,
        'totalVolume': totalVolume,
        'exercises': exercises.map((e) => e.toMap()).toList(),
        'date': date.toIso8601String(),
      };
}

class ExerciseSetRecord {
  final String name;
  final List<SetData> sets;

  const ExerciseSetRecord({required this.name, required this.sets});

  factory ExerciseSetRecord.fromMap(Map<String, dynamic> map) {
    return ExerciseSetRecord(
      name: map['name'] as String? ?? '',
      sets: (map['sets'] as List<dynamic>?)
              ?.map((s) => SetData.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'sets': sets.map((s) => s.toMap()).toList(),
      };
}

class SetData {
  final int reps;
  final double kg;
  final bool completed;

  const SetData({required this.reps, required this.kg, this.completed = false});

  factory SetData.fromMap(Map<String, dynamic> map) {
    return SetData(
      reps: map['reps'] as int? ?? 0,
      kg: (map['kg'] as num?)?.toDouble() ?? 0,
      completed: map['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'reps': reps,
        'kg': kg,
        'completed': completed,
      };
}

class CardioRecord {
  final String type;
  final int durationSeconds;
  final double distance;
  final double pace;
  final int calories;
  final DateTime date;

  const CardioRecord({
    required this.type,
    required this.durationSeconds,
    required this.distance,
    required this.pace,
    required this.calories,
    required this.date,
  });

  factory CardioRecord.fromMap(Map<String, dynamic> map) {
    return CardioRecord(
      type: map['type'] as String? ?? 'Corrida',
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      distance: (map['distance'] as num?)?.toDouble() ?? 0,
      pace: (map['pace'] as num?)?.toDouble() ?? 0,
      calories: map['calories'] as int? ?? 0,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'durationSeconds': durationSeconds,
        'distance': distance,
        'pace': pace,
        'calories': calories,
        'date': date.toIso8601String(),
      };
}

class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String activityLevel;
  final List<String> goals;
  final String injuries;
  final List<String> equipmentAccess;

  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    this.activityLevel = 'Moderado',
    this.goals = const [],
    this.injuries = '',
    this.equipmentAccess = const [],
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      age: map['age'] as int? ?? 25,
      gender: map['gender'] as String? ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 70,
      height: (map['height'] as num?)?.toDouble() ?? 170,
      activityLevel: map['activity_level'] as String? ?? 'Moderado',
      goals: (map['goals'] as List<dynamic>?)?.cast<String>() ?? [],
      injuries: map['injuries'] as String? ?? '',
      equipmentAccess:
          (map['equipment_access'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  double get bmi => weight / ((height / 100) * (height / 100));
}
