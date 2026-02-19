import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import '../../data/gym_exercises_data.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  final List<_ActiveExercise> _exercises = [];
  Timer? _timer;
  int _secondsElapsed = 0;
  final bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _exercises
        .add(_ActiveExercise(GymExercisesData.exercises[0]));
    _exercises.add(_ActiveExercise(GymExercisesData.exercises[5])); 
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() => _secondsElapsed++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _finishWorkout() {
    double totalVolume = 0;
    final List<Map<String, dynamic>> exerciseList = [];

    for (var activeEx in _exercises) {
      final List<Map<String, dynamic>> setsData = [];
      for (var set in activeEx.sets) {
        if (set.completed) {
          totalVolume += set.kg * set.reps;
        }
        setsData.add({
          'kg': set.kg,
          'reps': set.reps,
          'completed': set.completed,
        });
      }

      if (setsData.isNotEmpty) {
        exerciseList.add({
          'name': activeEx.exercise.name,
          'muscleGroup': activeEx.exercise.muscleGroup,
          'sets': setsData,
        });
      }
    }

    if (exerciseList.isNotEmpty) {
      final muscleGroups = exerciseList.map((e) => e['muscleGroup']).toList();
      String primaryGroup = 'Full Body';
      if (muscleGroups.isNotEmpty) {
        primaryGroup = muscleGroups
            .fold<Map<String, int>>({}, (map, element) {
              map[element] = (map[element] ?? 0) + 1;
              return map;
            })
            .entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }

      final duration = (_secondsElapsed / 60).round();

      context.read<AppProvider>().addGymWorkout(
            primaryGroup,
            exerciseList,
            duration,
            totalVolume,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino salvo com sucesso!'),
            backgroundColor: AsclepioTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('Active Workout', style: TextStyle(fontSize: 16)),
            Text(_formatTime(_secondsElapsed),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AsclepioTheme.primary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('FINISH',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AsclepioTheme.success)),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _exercises.length + 1,
        itemBuilder: (context, index) {
          if (index == _exercises.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
              ),
            );
          }
          return _ActiveExerciseCard(data: _exercises[index]);
        },
      ),
    );
  }
}

class _ActiveExercise {
  final GymExercise exercise;
  List<_ExerciseSet> sets = [
    _ExerciseSet(kg: 20, reps: 12),
    _ExerciseSet(kg: 20, reps: 12),
    _ExerciseSet(kg: 20, reps: 12),
  ];

  _ActiveExercise(this.exercise);
}

class _ExerciseSet {
  double kg;
  int reps;
  bool completed = false;
  _ExerciseSet({required this.kg, required this.reps});
}

class _ActiveExerciseCard extends StatefulWidget {
  final _ActiveExercise data;
  const _ActiveExerciseCard({required this.data});

  @override
  State<_ActiveExerciseCard> createState() => _ActiveExerciseCardState();
}

class _ActiveExerciseCardState extends State<_ActiveExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.data.exercise.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Row(
              children: [
                SizedBox(
                    width: 30,
                    child: Text("Set",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Center(
                        child: Text("kg",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(
                    child: Center(
                        child: Text("Reps",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                SizedBox(width: 40, child: Icon(Icons.check, size: 20)),
              ],
            ),
            const Divider(),
            ...widget.data.sets.asMap().entries.map((entry) {
              final i = entry.key;
              final set = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: set.completed
                    ? AsclepioTheme.success.withValues(alpha: 0.1)
                    : null,
                child: Row(
                  children: [
                    SizedBox(
                        width: 30,
                        child: Text("${i + 1}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: Text(set.kg.toStringAsFixed(0),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: Text("${set.reps}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Checkbox(
                        value: set.completed,
                        activeColor: AsclepioTheme.success,
                        onChanged: (v) =>
                            setState(() => set.completed = v ?? false),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      widget.data.sets.add(_ExerciseSet(kg: 0, reps: 0));
                    });
                  },
                  child: const Text('+ Add Set')),
            ),
          ],
        ),
      ),
    );
  }
}
