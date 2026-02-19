import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import '../../widgets/health_components.dart';

class ActivityDetailsPage extends StatelessWidget {
  final Map<String, dynamic>
      activity; // Mock: {date:, type: 'Run', distance: 5.2, time: 1800, calories: 450}

  const ActivityDetailsPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isGym = activity.containsKey('muscleGroup');
    // final date = DateTime.parse(activity['date'] ?? DateTime.now().toIso8601String());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isGym
            ? 'Treino ${activity['muscleGroup']}'
            : '${activity['type']} Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: isGym ? _buildGymDetails(context) : _buildCardioDetails(context),
      ),
    );
  }

  Widget _buildGymDetails(BuildContext context) {
    final exercises = (activity['exercises'] as List?) ?? [];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statBig('Volume', '${activity['totalVolume']} kg'),
            _statBig('Duração', '${activity['durationMinutes']} min'),
            _statBig('Exercícios', '${exercises.length}'),
          ],
        ),
        const SizedBox(height: 32),
        const SectionHeader(title: 'Exercícios'),
        ...exercises.map((ex) {
          final sets = (ex['sets'] as List?) ?? [];
          return HealthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex['name'] ?? 'Exercício',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                ...sets.map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${s['reps']} reps'),
                          Text('${s['kg']} kg'),
                          if (s['completed'] == true)
                            const Icon(Icons.check,
                                size: 16, color: AsclepioTheme.success)
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCardioDetails(BuildContext context) {
    return Column(
      children: [
        // ── Map Snapshot (Placeholder) ───────────────────────────────────
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            // In real app, integration with google static maps or flutter_map
            image: const DecorationImage(
              image: NetworkImage(
                  'https://static-maps.yandex.ru/1.x/?ll=-46.6333,-23.5505&z=13&l=map&size=600,300'),
              fit: BoxFit.cover,
            ),
            boxShadow: AsclepioTheme.shadowSm,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Mapa',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Main Stats ───────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statBig('Distância', '${activity['distance']} km'),
            _statBig('Tempo', _formatTime(activity['durationSeconds'] ?? 0)),
            _statBig(
                'Ritmo',
                _calculatePace(activity['durationSeconds'] ?? 0,
                    activity['distance'] ?? 0)),
          ],
        ),
        const SizedBox(height: 32),

        // ── Additional Stats ─────────────────────────────────────────────
        HealthCard(
          child: Column(
            children: [
              const SectionHeader(title: 'Análise'),
              _rowItem('Calorias Queimadas', '${activity['calories']} kcal'),
              const Divider(),
              _rowItem('Ganho de Elevação', '45 m'),
              const Divider(),
              _rowItem('Freq. Cardíaca Média', '145 bpm'),
              const Divider(),
              _rowItem('Freq. Cardíaca Máx', '178 bpm'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statBig(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto')),
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    return '${m}m';
  }

  String _calculatePace(int seconds, double dist) {
    if (dist == 0) return '-';
    final pace = seconds / 60 / dist;
    return '${pace.toStringAsFixed(2)} /km';
  }
}
