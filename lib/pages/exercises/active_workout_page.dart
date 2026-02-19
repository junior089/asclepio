import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isPaused = false;

  Timer? _restTimer;
  int _restSeconds = 0;
  bool _restActive = false;
  final int _restDuration = 90;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() => _secondsElapsed++);
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  void _addExerciseDialog() async {
    final exercise = await showModalBottomSheet<GymExercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollCtrl) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Selecionar Exercício',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount: GymExercisesData.exercises.length,
                  itemBuilder: (context, index) {
                    final ex = GymExercisesData.exercises[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AsclepioTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.fitness_center,
                            color: AsclepioTheme.primary, size: 20),
                      ),
                      title: Text(ex.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${ex.muscleGroup} • ${ex.equipment}'),
                      onTap: () => Navigator.pop(context, ex),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );

    if (exercise != null) {
      setState(() => _exercises.add(_ActiveExercise(exercise)));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _restActive = true;
      _restSeconds = _restDuration;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSeconds > 0) {
        setState(() => _restSeconds--);
      } else {
        _restTimer?.cancel();
        setState(() => _restActive = false);
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    setState(() => _restActive = false);
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
      final weight = context.read<AppProvider>().userWeight;
      final calories = (5.0 * weight * (duration / 60)).round();

      context.read<AppProvider>().addGymWorkout(
            primaryGroup,
            exerciseList,
            duration,
            totalVolume,
          );

      context.read<AppProvider>().activeCalories += calories;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Treino salvo! ~$calories kcal queimadas'),
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
            const Text('Treino Ativo', style: TextStyle(fontSize: 16)),
            Text(_formatTime(_secondsElapsed),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AsclepioTheme.primary)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
            tooltip: _isPaused ? 'Retomar' : 'Pausar',
          ),
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('FINALIZAR',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AsclepioTheme.success)),
          )
        ],
      ),
      body: _exercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Adicione exercícios para começar',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addExerciseDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Exercício'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _exercises.length + 1,
              itemBuilder: (context, index) {
                if (index == _exercises.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: OutlinedButton.icon(
                      onPressed: _addExerciseDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Exercício'),
                    ),
                  );
                }
                return _ActiveExerciseCard(
                  data: _exercises[index],
                  onRemove: () => setState(() => _exercises.removeAt(index)),
                );
              },
            ),
      floatingActionButton: _restActive
          ? FloatingActionButton.extended(
              onPressed: _stopRestTimer,
              backgroundColor: AsclepioTheme.primary,
              icon: const Icon(Icons.timer, color: Colors.white),
              label: Text(
                '${_restSeconds}s',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          : _exercises.isNotEmpty
              ? FloatingActionButton(
                  mini: true,
                  onPressed: _startRestTimer,
                  backgroundColor: AsclepioTheme.secondary,
                  tooltip: 'Descanso',
                  child: const Icon(Icons.timer, color: Colors.white),
                )
              : null,
    );
  }
}

class _ActiveExercise {
  final GymExercise exercise;
  List<_ExerciseSet> sets = [
    _ExerciseSet(kg: 0, reps: 12),
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
  final VoidCallback? onRemove;
  const _ActiveExerciseCard({required this.data, this.onRemove});

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
            Row(
              children: [
                Expanded(
                  child: Text(widget.data.exercise.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: widget.onRemove,
                    color: Colors.grey,
                  ),
              ],
            ),
            Text(widget.data.exercise.muscleGroup,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            const Row(
              children: [
                SizedBox(
                    width: 30,
                    child: Text('Série',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(
                    child: Center(
                        child: Text('kg',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)))),
                Expanded(
                    child: Center(
                        child: Text('Reps',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)))),
                SizedBox(width: 40, child: Icon(Icons.check, size: 20)),
              ],
            ),
            const Divider(),
            ...widget.data.sets.asMap().entries.map((entry) {
              final i = entry.key;
              final set = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: set.completed
                    ? AsclepioTheme.success.withValues(alpha: 0.1)
                    : null,
                child: Row(
                  children: [
                    SizedBox(
                        width: 30,
                        child: Text('${i + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 36,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                            controller: TextEditingController(
                                text: set.kg.toStringAsFixed(0)),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            onChanged: (v) {
                              set.kg = double.tryParse(v) ?? 0;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 36,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                            controller:
                                TextEditingController(text: '${set.reps}'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            onChanged: (v) {
                              set.reps = int.tryParse(v) ?? 0;
                            },
                          ),
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
                      final lastKg = widget.data.sets.isNotEmpty
                          ? widget.data.sets.last.kg
                          : 0.0;
                      widget.data.sets.add(_ExerciseSet(kg: lastKg, reps: 12));
                    });
                  },
                  child: const Text('+ Adicionar Série')),
            ),
          ],
        ),
      ),
    );
  }
}
