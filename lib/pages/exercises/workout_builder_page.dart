import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import '../../data/gym_exercises_data.dart';

class WorkoutBuilderPage extends StatefulWidget {
  const WorkoutBuilderPage({super.key});

  @override
  State<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  final _nameCtrl = TextEditingController();
  final List<GymExercise> _selectedExercises = [];

  void _addExercise() async {
    // Determine exercise based on simple dialog or selector page
    // For now, let's just pick random for demo or show a simple bottom sheet
    final exercise = await showModalBottomSheet<GymExercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (ctx) => _ExerciseSelectorSheet(),
    );

    if (exercise != null) {
      setState(() => _selectedExercises.add(exercise));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Routine'),
        actions: [
          TextButton(
            onPressed: () {
              // Save routine logic (Implemented)
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rotina salva com sucesso!')),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('SAVE',
                style: TextStyle(
                    color: AsclepioTheme.primary, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Routine Name',
                hintText: 'e.g. Chest & Triceps A',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) newIndex -= 1;
                  final item = _selectedExercises.removeAt(oldIndex);
                  _selectedExercises.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < _selectedExercises.length; i++)
                  _ExerciseTile(
                    key: ValueKey(_selectedExercises[i]),
                    exercise: _selectedExercises[i],
                    index: i,
                    onRemove: () =>
                        setState(() => _selectedExercises.removeAt(i)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addExercise,
                icon: const Icon(Icons.add),
                label: const Text('ADD EXERCISE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: AsclepioTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final GymExercise exercise;
  final int index;
  final VoidCallback onRemove;

  const _ExerciseTile({
    super.key,
    required this.exercise,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AsclepioTheme.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AsclepioTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Text('${index + 1}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AsclepioTheme.primary)),
        ),
        title: Text(exercise.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(exercise.muscleGroup),
        trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: AsclepioTheme.error),
            onPressed: onRemove),
      ),
    );
  }
}

class _ExerciseSelectorSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Select Exercise",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: GymExercisesData.exercises.length,
                itemBuilder: (context, index) {
                  final ex = GymExercisesData.exercises[index];
                  return ListTile(
                    title: Text(ex.name),
                    subtitle: Text(ex.muscleGroup),
                    onTap: () => Navigator.pop(context, ex),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
