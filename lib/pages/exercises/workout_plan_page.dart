import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/gym_exercises_data.dart';

class WorkoutPlanPage extends StatelessWidget {
  const WorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final currentPlan = provider.weeklyPlan;
        final dayNames = [
          'Segunda',
          'Terça',
          'Quarta',
          'Quinta',
          'Sexta',
          'Sábado',
          'Domingo'
        ];

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Plano Semanal'),
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded,
                    color: AppTheme.primary),
                onPressed: () => _showTemplates(context, provider),
                tooltip: 'Templates',
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: 7,
            itemBuilder: (context, index) {
              final plan = currentPlan[index] ?? 'Sem treino';
              final isToday = DateTime.now().weekday - 1 == index;
              final isRest = plan.contains('Descanso') || plan == 'Sem treino';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppTheme.primary.withValues(alpha: 0.06)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                  border: isToday
                      ? Border.all(color: AppTheme.primary, width: 1.5)
                      : null,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isRest
                          ? AppTheme.surfaceVariant
                          : isToday
                              ? AppTheme.primary
                              : AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        dayNames[index].substring(0, 3),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isRest
                              ? AppTheme.textLight
                              : (isToday ? Colors.white : AppTheme.primary),
                        ),
                      ),
                    ),
                  ),
                  title: Text(dayNames[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isToday
                              ? AppTheme.primary
                              : AppTheme.textPrimary)),
                  subtitle: Text(plan,
                      style: TextStyle(
                          fontSize: 13,
                          color: isRest
                              ? AppTheme.textLight
                              : AppTheme.textSecondary)),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        size: 18, color: AppTheme.textLight),
                    onPressed: () => _editDay(
                        context, provider, index, dayNames[index], plan),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static void _editDay(BuildContext context, AppProvider provider, int dayIndex,
      String dayName, String current) {
    final ctrl =
        TextEditingController(text: current == 'Sem treino' ? '' : current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(dayName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(
                controller: ctrl,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Ex: Peito + Tríceps')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      provider.updateWeeklyPlan(dayIndex, 'Descanso');
                      Navigator.pop(ctx);
                    },
                    child: const Text('Descanso'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final text = ctrl.text.trim();
                      if (text.isNotEmpty) {
                        provider.updateWeeklyPlan(dayIndex, text);
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _showTemplates(BuildContext context, AppProvider provider) {
    const templates = GymExercisesData.workoutTemplates;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Templates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Tap para aplicar ao plano semanal',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            ...templates.entries.map((tmpl) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: AppTheme.cardDecoration,
                child: ListTile(
                  title: Text(tmpl.key,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(tmpl.value.values.take(3).join(' • '),
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary),
                      overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.arrow_forward_rounded,
                      color: AppTheme.primary, size: 18),
                  onTap: () {
                    for (final entry in tmpl.value.entries) {
                      provider.updateWeeklyPlan(entry.key, entry.value);
                    }
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Template "${tmpl.key}" aplicado!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.primary),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
