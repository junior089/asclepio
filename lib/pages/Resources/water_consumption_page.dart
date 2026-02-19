import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class WaterConsumptionPage extends StatelessWidget {
  const WaterConsumptionPage({super.key});

  static const List<int> _amounts = [150, 200, 250, 350, 500];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final progress = provider.dailyWaterGoal > 0
            ? (provider.waterConsumed / provider.dailyWaterGoal).clamp(0.0, 1.0)
            : 0.0;
        final percentage = (progress * 100).round();

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(title: const Text('Hidratação')),
          body: CustomScrollView(
            slivers: [
              // ── Indicador circular ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  AppTheme.water.withValues(alpha: 0.12),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.water),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.water_drop_rounded,
                                  color: AppTheme.water, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                '${provider.waterConsumed.toInt()} ml',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Meta: ${provider.dailyWaterGoal.toInt()} ml',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary),
                              ),
                              Text(
                                '$percentage%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: progress >= 1
                                      ? AppTheme.steps
                                      : AppTheme.water,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Botões de adicionar ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: AppTheme.cardDecoration,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adicionar Água',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _amounts.map((amount) {
                            return GestureDetector(
                              onTap: () => provider.addWater(amount.toDouble()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.water.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppTheme.water
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.water_drop_outlined,
                                        color: AppTheme.water, size: 18),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${amount}ml',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.water,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Histórico do dia ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Hoje (${provider.waterConsumptionLog.length} registros)',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              if (provider.waterConsumptionLog.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.water_drop_outlined,
                              size: 48, color: AppTheme.textLight),
                          SizedBox(height: 8),
                          Text(
                            'Nenhum registro hoje',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Mostrar em ordem reversa (mais recente primeiro)
                        final realIndex =
                            provider.waterConsumptionLog.length - 1 - index;
                        final entry = provider.waterConsumptionLog[realIndex];
                        final amount = (entry['amount'] as num).toInt();
                        String timeStr = '';
                        try {
                          final dt = DateTime.parse(entry['time']);
                          timeStr = DateFormat('HH:mm').format(dt);
                        } catch (_) {}

                        return Dismissible(
                          key: Key('water_$realIndex'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.red),
                          ),
                          onDismissed: (_) => provider.removeWater(realIndex),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: AppTheme.cardDecoration,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.water.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.water_drop_rounded,
                                      color: AppTheme.water, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '$amount ml',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                const Spacer(),
                                Text(timeStr,
                                    style: const TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: provider.waterConsumptionLog.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }
}
