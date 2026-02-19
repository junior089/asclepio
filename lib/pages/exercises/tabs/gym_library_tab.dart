import 'package:flutter/material.dart';
import '../../../data/gym_exercises_data.dart';
import '../../../theme/asclepio_theme.dart';
import '../exercise_detail_gym_page.dart';

class GymLibraryTab extends StatelessWidget {
  const GymLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        // Using CSV for potential sliver effects manually if needed
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final group = GymExercisesData.muscleGroups[index];
                  final exercises = GymExercisesData.getByMuscleGroup(group);
                  final emoji =
                      GymExercisesData.muscleGroupIcons[group] ?? '💪';

                  return _MuscleGroupCard(
                    name: group,
                    count: exercises.length,
                    emoji: emoji,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _ExerciseListPage(
                            muscleGroup: group, exercises: exercises),
                      ),
                    ),
                  );
                },
                childCount: GymExercisesData.muscleGroups.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _MuscleGroupCard extends StatelessWidget {
  final String name;
  final int count;
  final String emoji;
  final VoidCallback onTap;

  const _MuscleGroupCard({
    required this.name,
    required this.count,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AsclepioTheme.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$count exercises',
                style: TextStyle(
                    color: Theme.of(context).disabledColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ExerciseListPage extends StatelessWidget {
  final String muscleGroup;
  final List<GymExercise> exercises;

  const _ExerciseListPage({required this.muscleGroup, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(muscleGroup)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AsclepioTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fitness_center,
                    color: AsclepioTheme.primary),
              ),
              title: Text(ex.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${ex.equipment} • ${ex.difficulty}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ExerciseDetailGymPage(
                        exercise: ex, muscleGroup: muscleGroup)),
              ),
            ),
          );
        },
      ),
    );
  }
}
