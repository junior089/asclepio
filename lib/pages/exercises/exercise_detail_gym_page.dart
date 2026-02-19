import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/gym_exercises_data.dart';
import '../../theme/app_theme.dart';

class ExerciseDetailGymPage extends StatefulWidget {
  final GymExercise exercise;
  final String muscleGroup;
  const ExerciseDetailGymPage(
      {super.key, required this.exercise, required this.muscleGroup});

  @override
  State<ExerciseDetailGymPage> createState() => _ExerciseDetailGymPageState();
}

class _ExerciseDetailGymPageState extends State<ExerciseDetailGymPage> {
  // Séries
  final List<Map<String, int>> _sets = [];
  final _repsCtrl = TextEditingController(text: '12');
  final _weightCtrl = TextEditingController(text: '20');

  // Timer
  Timer? _timer;
  int _restSeconds = 0;
  int _restGoal = 90;
  bool _timerRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _addSet() {
    final reps = int.tryParse(_repsCtrl.text) ?? 12;
    final weight = int.tryParse(_weightCtrl.text) ?? 0;
    setState(() => _sets.add({'reps': reps, 'weight': weight}));
    _startRest();
  }

  void _startRest() {
    _timer?.cancel();
    setState(() {
      _restSeconds = _restGoal;
      _timerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restSeconds <= 0) {
        t.cancel();
        setState(() => _timerRunning = false);
      } else {
        setState(() => _restSeconds--);
      }
    });
  }

  void _skipRest() {
    _timer?.cancel();
    setState(() {
      _restSeconds = 0;
      _timerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final diffColor = ex.difficulty == 'Iniciante'
        ? const Color(0xFF4CAF50)
        : ex.difficulty == 'Intermediário'
            ? const Color(0xFFFF9800)
            : AppTheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
          title: Text(ex.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: diffColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(ex.difficulty,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: diffColor)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(ex.equipment,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (ex.primaryMuscle.isNotEmpty)
                    _infoRow('Músculo Principal', ex.primaryMuscle),
                  if (ex.secondaryMuscles.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _infoRow(
                        'Músculos Secundários', ex.secondaryMuscles.join(', ')),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Instruções ──────────────────────────────────────────
            if (ex.instructions.isNotEmpty) ...[
              const Text('Como Fazer',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 10),
              ...ex.instructions.asMap().entries.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: AppTheme.cardDecoration,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text('${e.key + 1}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(e.value,
                              style:
                                  const TextStyle(fontSize: 14, height: 1.4))),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],

            // ── Rest Timer ──────────────────────────────────────────
            if (_timerRunning)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.timer_rounded,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Descanso',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white70)),
                          Text('${_restSeconds}s',
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipRest,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text('Pular',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Adicionar Série ──────────────────────────────────────
            const Text('Registrar Série',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 10),

            // Timer preset
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Text('Descanso: ',
                      style: TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary)),
                  ...([60, 90, 120, 180]).map((s) {
                    final sel = s == _restGoal;
                    return GestureDetector(
                      onTap: () => setState(() => _restGoal = s),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              sel ? AppTheme.primary : AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${s}s',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                color: sel
                                    ? Colors.white
                                    : AppTheme.textSecondary)),
                      ),
                    );
                  }),
                ],
              ),
            ),

            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg)',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _repsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Reps',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addSet,
                      child: const Icon(Icons.add_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── SetList ──────────────────────────────────────────────
            if (_sets.isNotEmpty) ...[
              const Text('Séries',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              ..._sets.asMap().entries.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: AppTheme.cardDecoration,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text('${e.key + 1}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary))),
                      ),
                      const SizedBox(width: 14),
                      Text('${e.value['weight']}kg',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const Text(' × ',
                          style: TextStyle(color: AppTheme.textLight)),
                      Text('${e.value['reps']} reps',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _sets.removeAt(e.key)),
                        child: const Icon(Icons.close_rounded,
                            color: AppTheme.textLight, size: 18),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary)),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary))),
      ],
    );
  }
}
