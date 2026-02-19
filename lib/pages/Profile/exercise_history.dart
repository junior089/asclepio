import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final history = provider.exerciseHistory;

        if (history.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum exercício concluído ainda.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Complete um exercício para ver o histórico aqui.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Calcular totais
        final totalMinutes = history.fold<int>(
            0, (sum, e) => sum + (e['duration'] as int? ?? 0));
        final totalCalories = history.fold<int>(
            0, (sum, e) => sum + (e['calories'] as int? ?? 0));

        return Column(
          children: [
            // Resumo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: AppTheme.primary.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem('${history.length}', 'Exercícios',
                          Icons.check_circle_outline),
                      _summaryItem(
                          '${totalMinutes}min', 'Total', Icons.timer_outlined),
                      _summaryItem('~${totalCalories}kcal', 'Calorias',
                          Icons.local_fire_department_outlined),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final exercise = history[index];
                  DateTime? date;
                  try {
                    date = DateTime.parse(exercise['date'] ?? '');
                  } catch (_) {}

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.fitness_center,
                            color: AppTheme.primary),
                      ),
                      title: Text(
                        exercise['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${exercise['duration']} min · ${exercise['type']} · ~${exercise['calories']} kcal',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      trailing: Text(
                        date != null ? DateFormat('dd/MM').format(date) : '',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary)),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
