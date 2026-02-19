import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';
import '../auth_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, p, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              // ── Header com gradiente ──────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                      child: Column(
                        children: [
                          // Top bar
                          Row(
                            children: [
                              const Text('Perfil',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.settings_rounded,
                                    color: Colors.white70),
                                onPressed: () => _showSettings(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Avatar + Info
                          Row(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      width: 2),
                                ),
                                child: const Icon(Icons.person_rounded,
                                    color: Colors.white, size: 36),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.userName,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
                                    const SizedBox(height: 4),
                                    Text('${p.userAge} anos • ${p.userGender}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                                .withValues(alpha: 0.8))),
                                    Text(p.userGoal,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white
                                                .withValues(alpha: 0.7))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Stats inline
                          Row(
                            children: [
                              _headerStat('IMC', p.bmi.toStringAsFixed(1)),
                              _divider(),
                              _headerStat('Peso',
                                  '${p.userWeight.toStringAsFixed(1)} kg'),
                              _divider(),
                              _headerStat('Altura',
                                  '${p.userHeight.toStringAsFixed(0)} cm'),
                              _divider(),
                              _headerStat('Sangue', p.bloodType),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Gráfico de Peso ──────────────────────────────────────
              if (p.weightHistory.length > 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Container(
                      decoration: AppTheme.cardDecoration,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Evolução de Peso',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 160,
                            child:
                                LineChart(_buildWeightChart(p.weightHistory)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Editar Perfil ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dados Pessoais',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                      const SizedBox(height: 12),
                      _profileRow(
                          context,
                          Icons.person_rounded,
                          'Nome',
                          p.userName,
                          () => _editField(context, 'Nome', p.userName,
                              (v) => p.updateProfile(name: v))),
                      _profileRow(
                          context,
                          Icons.cake_rounded,
                          'Idade',
                          '${p.userAge} anos',
                          () => _editNumber(context, 'Idade', p.userAge, 10,
                              100, (v) => p.updateProfile(age: v))),
                      _profileRow(
                          context,
                          Icons.monitor_weight_rounded,
                          'Peso',
                          '${p.userWeight.toStringAsFixed(1)} kg',
                          () => _editWeight(context, p)),
                      _profileRow(
                          context,
                          Icons.height_rounded,
                          'Altura',
                          '${p.userHeight.toStringAsFixed(0)} cm',
                          () => _editDecimal(context, 'Altura (cm)',
                              p.userHeight, (v) => p.updateProfile(height: v))),
                    ],
                  ),
                ),
              ),

              // ── Resumo de Atividades ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resumo',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _summaryCard('🏋️', '${p.gymHistory.length}',
                              'Treinos', AppTheme.primary),
                          const SizedBox(width: 12),
                          _summaryCard('🏃', '${p.cardioHistory.length}',
                              'Cardio', const Color(0xFF4CAF50)),
                          const SizedBox(width: 12),
                          _summaryCard('📝', '${p.symptomsHistory.length}',
                              'Sintomas', const Color(0xFFFF9800)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Logout ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sair da Conta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
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

  // ── Helpers ───────────────────────────────────────────────────────────────
  static Widget _headerStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  static Widget _divider() {
    return Container(
        width: 1, height: 32, color: Colors.white.withValues(alpha: 0.2));
  }

  static Widget _profileRow(BuildContext context, IconData icon, String label,
      String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(width: 14),
            Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  static Widget _summaryCard(
      String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  static LineChartData _buildWeightChart(List<Map<String, dynamic>> history) {
    final spots = <FlSpot>[];
    final recent =
        history.length > 14 ? history.sublist(history.length - 14) : history;
    for (var i = 0; i < recent.length; i++) {
      final w = (recent[i]['weight'] as num?)?.toDouble() ?? 0;
      spots.add(FlSpot(i.toDouble(), w));
    }
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2;

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppTheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
              radius: 3,
              color: AppTheme.primary,
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────
  static void _editField(BuildContext context, String label, String current,
      Function(String) onSave) {
    final ctrl = TextEditingController(text: current);
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
            Text('Editar $label',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(controller: ctrl, autofocus: true),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  onSave(ctrl.text.trim());
                  Navigator.pop(ctx);
                },
                child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }

  static void _editNumber(BuildContext context, String label, int current,
      int min, int max, Function(int) onSave) {
    int value = current;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Editar $label',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Center(
                  child: Text('$value',
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary))),
              Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  onChanged: (v) => setState(() => value = v.round())),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    onSave(value);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }

  static void _editDecimal(BuildContext context, String label, double current,
      Function(double) onSave) {
    final ctrl = TextEditingController(text: current.toStringAsFixed(1));
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
            Text('Editar $label',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                autofocus: true),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(ctrl.text) ?? current;
                  onSave(v);
                  Navigator.pop(ctx);
                },
                child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }

  static void _editWeight(BuildContext context, AppProvider provider) {
    final ctrl =
        TextEditingController(text: provider.userWeight.toStringAsFixed(1));
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
            const Text('Registrar Peso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(suffixText: 'kg')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final w = double.tryParse(ctrl.text) ?? provider.userWeight;
                provider.addWeightEntry(w);
                Navigator.pop(ctx);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  static void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Configurações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('Versão'),
              trailing: Text('2.0.0',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety_rounded),
              title: Text('Sobre o Asclépio'),
              subtitle: Text('App de saúde e bem-estar'),
            ),
          ],
        ),
      ),
    );
  }

  static void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da conta?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                  (route) => false,
                );
              }
            },
            child:
                const Text('Sair', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}
