import 'package:flutter/material.dart';
import '../../../theme/asclepio_theme.dart';
import '../../../widgets/health_components.dart';
import '../active_workout_page.dart';
import '../workout_builder_page.dart';

class GymRoutinesTab extends StatelessWidget {
  const GymRoutinesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Quick Actions ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    context,
                    'Início Rápido',
                    Icons.play_arrow_rounded,
                    AsclepioTheme.primary,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ActiveWorkoutPage())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    context,
                    'Nova Rotina',
                    Icons.add_rounded,
                    AsclepioTheme.secondary,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WorkoutBuilderPage())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── My Routines ──────────────────────────────────────────────────
            const SectionHeader(title: 'Minhas Rotinas'),

            // Mock Data for now - will connect to Supabase later
            _routineCard(context, 'Treino de Empurrar', '6 Exercícios • 45m',
                DateTime.now().subtract(const Duration(days: 2))),
            _routineCard(context, 'Treino de Puxar', '7 Exercícios • 50m',
                DateTime.now().subtract(const Duration(days: 4))),
            _routineCard(context, 'Pernas A', '5 Exercícios • 60m',
                DateTime.now().subtract(const Duration(days: 6))),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AsclepioTheme.shadowSm,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _routineCard(BuildContext context, String name, String details,
      DateTime lastPerformed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: HealthCard(
        onTap: () {}, // Open routine details
        child: Row(
          children: [
            Container(
              height: 60,
              width: 6,
              decoration: BoxDecoration(
                color: AsclepioTheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(details, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
