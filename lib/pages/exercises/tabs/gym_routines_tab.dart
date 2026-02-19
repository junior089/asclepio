import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/asclepio_theme.dart';
import '../../../widgets/health_components.dart';
import '../../../services/supabase_service.dart';
import '../active_workout_page.dart';
import '../workout_builder_page.dart';

class GymRoutinesTab extends StatefulWidget {
  const GymRoutinesTab({super.key});

  @override
  State<GymRoutinesTab> createState() => _GymRoutinesTabState();
}

class _GymRoutinesTabState extends State<GymRoutinesTab> {
  List<Map<String, dynamic>> _routines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    setState(() => _loading = true);
    final data = await SupabaseService.instance.loadRoutines();
    if (mounted) {
      setState(() {
        _routines = data;
        _loading = false;
      });
    }
  }

  Future<void> _deleteRoutine(String id) async {
    await SupabaseService.instance.deleteRoutine(id);
    _loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadRoutines,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Quick Actions ──────────────────────────────────────────
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
                      () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WorkoutBuilderPage()));
                        _loadRoutines(); // Refresh after returning
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── My Routines ────────────────────────────────────────────
              const SectionHeader(title: 'Minhas Rotinas'),

              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_routines.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('Nenhuma rotina criada',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600)),
                        const SizedBox(height: 4),
                        Text('Toque em "Nova Rotina" para começar',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                )
              else
                ..._routines.map((routine) => _routineCard(
                      context,
                      routine['name'] ?? 'Rotina',
                      _routineSubtitle(routine),
                      routine['id'],
                      routine['exercises'] as List<dynamic>?,
                    )),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String _routineSubtitle(Map<String, dynamic> routine) {
    final exercises = routine['exercises'] as List<dynamic>?;
    final count = exercises?.length ?? 0;
    return '$count Exercício${count != 1 ? 's' : ''}';
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
      String? routineId, List<dynamic>? exercises) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: HealthCard(
        onTap: () {
          HapticFeedback.selectionClick();
          // Start workout with this routine's exercises
          if (exercises != null && exercises.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ActiveWorkoutPage(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Adicione exercícios à rotina primeiro'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
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
            PopupMenuButton<String>(
              icon:
                  Icon(Icons.more_vert, color: Theme.of(context).disabledColor),
              onSelected: (value) {
                if (value == 'delete' && routineId != null) {
                  _deleteRoutine(routineId);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Excluir'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
