import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';
import '../../../widgets/health_components.dart';
import '../../activities/activity_details_page.dart';
import '../../../theme/asclepio_theme.dart';

class GymHistoryTab extends StatelessWidget {
  const GymHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final history = provider.gymHistory;

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Sem histórico de treinos',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final workout = history[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HealthCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActivityDetailsPage(activity: workout),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            workout['muscleGroup'] ?? 'Treino',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            _formatDate(workout['date']),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${workout['durationMinutes']} min • ${workout['exercises'].length} Exercícios',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Volume Total: ${workout['totalVolume']} kg',
                        style: const TextStyle(
                            color: AsclepioTheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.parse(isoDate);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
