import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, p, _) {
        final moveProgress =
            p.stepsGoal > 0 ? (p.steps / p.stepsGoal).clamp(0.0, 1.0) : 0.0;
        final exProgress = p.moveMinutesGoal > 0
            ? (p.activityMinutes / p.moveMinutesGoal).clamp(0.0, 1.0)
            : 0.0;
        final calProgress = p.caloriesGoal > 0
            ? (p.activeCalories / p.caloriesGoal).clamp(0.0, 1.0)
            : 0.0;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${p.userName.split(' ').first}',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.5),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _greeting(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Activity Rings ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Rings
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _ring(130, moveProgress, AppTheme.moveRing),
                              _ring(100, exProgress, AppTheme.exerciseRing),
                              _ring(70, calProgress, AppTheme.standRing),
                              const Icon(Icons.directions_walk_rounded,
                                  color: AppTheme.textLight, size: 22),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ringLabel('Passos', '${p.steps.toInt()}',
                                  '/${p.stepsGoal}', AppTheme.moveRing),
                              const SizedBox(height: 14),
                              _ringLabel(
                                  'Exercício',
                                  '${p.activityMinutes.toInt()}',
                                  '/${p.moveMinutesGoal} min',
                                  AppTheme.exerciseRing),
                              const SizedBox(height: 14),
                              _ringLabel(
                                  'Calorias',
                                  '${p.activeCalories.toInt()}',
                                  '/${p.caloriesGoal} kcal',
                                  AppTheme.standRing),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Stats Grid ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      _statCard(
                          '❤️', '${p.heartRate}', 'BPM', AppTheme.primary),
                      const SizedBox(width: 12),
                      _statCard('🌡️', p.bodyTemp.toStringAsFixed(1), '°C',
                          const Color(0xFFFF9800)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Row(
                    children: [
                      _statCard('🩸', p.bloodPressure, 'mmHg',
                          const Color(0xFF7B1FA2)),
                      const SizedBox(width: 12),
                      _statCard(
                          '💧',
                          '${((p.waterConsumed / p.dailyWaterGoal.clamp(1, double.infinity)) * 100).toInt()}%',
                          'Água',
                          const Color(0xFF2196F3)),
                    ],
                  ),
                ),
              ),

              // ── IMC Card ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _bmiColor(p.bmi).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              p.bmi.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: _bmiColor(p.bmi)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Índice de Massa Corporal',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary)),
                              const SizedBox(height: 4),
                              Text(
                                _bmiCategory(p.bmi),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: _bmiColor(p.bmi),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${p.userWeight.toStringAsFixed(1)} kg',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700)),
                            Text('${p.userHeight.toStringAsFixed(0)} cm',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Última Atividade ────────────────────────────────────────
              if (p.gymHistory.isNotEmpty || p.cardioHistory.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Atividade Recente',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary)),
                        const SizedBox(height: 12),
                        if (p.gymHistory.isNotEmpty)
                          _activityCard(
                            Icons.fitness_center_rounded,
                            p.gymHistory.first['muscleGroup'] ?? 'Treino',
                            '${(p.gymHistory.first['exercises'] as List?)?.length ?? 0} exercícios • ${p.gymHistory.first['durationMinutes'] ?? 0}min',
                            AppTheme.primary,
                          ),
                        if (p.cardioHistory.isNotEmpty)
                          _activityCard(
                            Icons.directions_run_rounded,
                            p.cardioHistory.first['type'] ?? 'Corrida',
                            '${(p.cardioHistory.first['distance'] as num?)?.toStringAsFixed(2) ?? '0'} km • ${p.cardioHistory.first['calories'] ?? 0} kcal',
                            const Color(0xFF4CAF50),
                          ),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia! ☀️';
    if (h < 18) return 'Boa tarde! 🌤️';
    return 'Boa noite! 🌙';
  }

  static Widget _ring(double size, double progress, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 10,
        strokeCap: StrokeCap.round,
        backgroundColor: color.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  static Widget _ringLabel(
      String label, String value, String suffix, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
            children: [
              TextSpan(
                  text: '$label ',
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500)),
              TextSpan(
                  text: value,
                  style: TextStyle(color: color, fontWeight: FontWeight.w800)),
              TextSpan(
                  text: suffix,
                  style:
                      const TextStyle(color: AppTheme.textLight, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _statCard(String emoji, String value, String label, Color color,
      {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: AppTheme.cardDecoration,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary)),
                    Text(label,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _activityCard(
      IconData icon, String title, String subtitle, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  static Color _bmiColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF2196F3);
    if (bmi < 25) return const Color(0xFF4CAF50);
    if (bmi < 30) return const Color(0xFFFF9800);
    return AppTheme.primary;
  }

  static String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Abaixo do peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidade';
  }
}
