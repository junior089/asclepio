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
            Text('$count exercício${count != 1 ? 's' : ''}',
                style: TextStyle(
                    color: Theme.of(context).disabledColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ExerciseListPage extends StatefulWidget {
  final String muscleGroup;
  final List<GymExercise> exercises;

  const _ExerciseListPage({required this.muscleGroup, required this.exercises});

  @override
  State<_ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<_ExerciseListPage> {
  final _searchCtrl = TextEditingController();
  String _difficultyFilter = 'Todos';
  String _equipmentFilter = 'Todos';

  List<GymExercise> get _filtered {
    return widget.exercises.where((ex) {
      final query = _searchCtrl.text.toLowerCase();
      if (query.isNotEmpty && !ex.name.toLowerCase().contains(query)) {
        return false;
      }
      if (_difficultyFilter != 'Todos' && ex.difficulty != _difficultyFilter) {
        return false;
      }
      if (_equipmentFilter != 'Todos' && ex.equipment != _equipmentFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final equipments = {'Todos', ...widget.exercises.map((e) => e.equipment)};
    final difficulties = {
      'Todos',
      ...widget.exercises.map((e) => e.difficulty)
    };

    return Scaffold(
      appBar: AppBar(title: Text(widget.muscleGroup)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar exercício...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _filterChip(
                      'Dificuldade', _difficultyFilter, difficulties.toList(),
                      (v) {
                    setState(() => _difficultyFilter = v);
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _filterChip(
                      'Equipamento', _equipmentFilter, equipments.toList(),
                      (v) {
                    setState(() => _equipmentFilter = v);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} exercício${filtered.length != 1 ? 's' : ''} encontrado${filtered.length != 1 ? 's' : ''}',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).disabledColor),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('Nenhum exercício encontrado',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final ex = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  AsclepioTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.fitness_center,
                                color: AsclepioTheme.primary),
                          ),
                          title: Text(ex.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${ex.equipment} • ${ex.difficulty}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ExerciseDetailGymPage(
                                    exercise: ex,
                                    muscleGroup: widget.muscleGroup)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String current, List<String> options,
      ValueChanged<String> onChanged) {
    return GestureDetector(
      onTap: () {
        final idx = options.indexOf(current);
        final next = options[(idx + 1) % options.length];
        onChanged(next);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: current != 'Todos'
              ? AsclepioTheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: current != 'Todos'
                ? AsclepioTheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list,
                size: 16, color: Theme.of(context).disabledColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                current == 'Todos' ? label : current,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      current != 'Todos' ? FontWeight.w600 : FontWeight.normal,
                  color: current != 'Todos' ? AsclepioTheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
