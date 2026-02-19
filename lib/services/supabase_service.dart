import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton para todas as operações Supabase.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get _client => Supabase.instance.client;

  // ════════════════════════════════════════════════════════════════════════════
  // AUTH
  // ════════════════════════════════════════════════════════════════════════════
  String? get currentUserId => _client.auth.currentUser?.id;
  bool get isLoggedIn => _client.auth.currentUser != null;

  Future<AuthResponse> signUp(String email, String password) =>
      _client.auth.signUp(email: email, password: password);

  Future<AuthResponse> signIn(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  // ════════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveProfile(Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('profiles').upsert({
        'id': uid,
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Erro ao salvar perfil: $e');
    }
  }

  Future<Map<String, dynamic>?> loadProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;
    try {
      return await _client
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');
      return null;
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // WORKOUTS (musculação)
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveWorkout(Map<String, dynamic> workout) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('workouts').insert({
        'user_id': uid,
        ...workout,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Erro ao salvar treino: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadWorkouts({int limit = 50}) async {
    final uid = currentUserId;
    if (uid == null) return [];
    try {
      final res = await _client
          .from('workouts')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Erro ao carregar treinos: $e');
      return [];
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // CARDIO
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveCardio(Map<String, dynamic> activity) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('cardio_activities').insert({
        'user_id': uid,
        ...activity,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Erro ao salvar cardio: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadCardio({int limit = 50}) async {
    final uid = currentUserId;
    if (uid == null) return [];
    try {
      final res = await _client
          .from('cardio_activities')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Erro ao carregar cardio: $e');
      return [];
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // WATER
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveWaterEntry(Map<String, dynamic> entry) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('water_logs').insert({
        'user_id': uid,
        ...entry,
      });
    } catch (e) {
      debugPrint('Erro ao salvar água: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadWaterLogs(String date) async {
    final uid = currentUserId;
    if (uid == null) return [];
    try {
      final res = await _client
          .from('water_logs')
          .select()
          .eq('user_id', uid)
          .gte('created_at', '${date}T00:00:00')
          .lte('created_at', '${date}T23:59:59')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Erro ao carregar logs de água: $e');
      return [];
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // WEIGHT HISTORY
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveWeightEntry(double weight) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('weight_history').insert({
        'user_id': uid,
        'weight': weight,
        'recorded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Erro ao salvar peso: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadWeightHistory({int limit = 30}) async {
    final uid = currentUserId;
    if (uid == null) return [];
    try {
      final res = await _client
          .from('weight_history')
          .select()
          .eq('user_id', uid)
          .order('recorded_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Erro ao carregar histórico de peso: $e');
      return [];
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // WEEKLY PLAN
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveWeeklyPlan(Map<String, dynamic> plan) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      await _client.from('weekly_plans').upsert({
        'user_id': uid,
        'plan': plan,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Erro ao salvar plano semanal: $e');
    }
  }

  Future<Map<String, dynamic>?> loadWeeklyPlan() async {
    final uid = currentUserId;
    if (uid == null) return null;
    try {
      return await _client
          .from('weekly_plans')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
    } catch (e) {
      debugPrint('Erro ao carregar plano semanal: $e');
      return null;
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ROUTINES
  // ════════════════════════════════════════════════════════════════════════════
  Future<void> saveRoutine({
    String? id,
    required String name,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    try {
      final data = <String, dynamic>{
        'user_id': uid,
        'name': name,
        'exercises': exercises,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (id != null) {
        data['id'] = id;
      }
      await _client.from('routines').upsert(data);
    } catch (e) {
      debugPrint('Erro ao salvar rotina: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadRoutines() async {
    final uid = currentUserId;
    if (uid == null) return [];
    try {
      final res = await _client
          .from('routines')
          .select()
          .eq('user_id', uid)
          .order('updated_at', ascending: false);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Erro ao carregar rotinas: $e');
      return [];
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await _client.from('routines').delete().eq('id', id);
    } catch (e) {
      debugPrint('Erro ao deletar rotina: $e');
    }
  }
}
