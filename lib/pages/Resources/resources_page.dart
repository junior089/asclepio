import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'water_consumption_page.dart';
import 'disease_outbreaks_page.dart';
import 'menstrual_cycle_page.dart';
import 'cleaning_products_page.dart';
import '../nearby_hospitals_page.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recursos',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5)),
                    SizedBox(height: 4),
                    Text('Ferramentas para sua saúde',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ),
          ),

          // Grid 2x2
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildListDelegate([
                _ResourceTile(
                  icon: Icons.water_drop_rounded,
                  title: 'Água',
                  subtitle: 'Consumo diário',
                  color: const Color(0xFF2196F3),
                  onTap: () => _navigate(context, const WaterConsumptionPage()),
                ),
                _ResourceTile(
                  icon: Icons.local_hospital_rounded,
                  title: 'Hospitais',
                  subtitle: 'Próximos a você',
                  color: const Color(0xFFE53935),
                  onTap: () => _navigate(context, const NearbyHospitalsPage()),
                ),
                _ResourceTile(
                  icon: Icons.coronavirus_rounded,
                  title: 'Surtos',
                  subtitle: 'Informações',
                  color: const Color(0xFFFF9800),
                  onTap: () => _navigate(context, const DiseaseOutbreaksPage()),
                ),
                _ResourceTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'Ciclo',
                  subtitle: 'Menstrual',
                  color: const Color(0xFFE91E63),
                  onTap: () => _navigate(context, const MenstrualCyclePage()),
                ),
              ]),
            ),
          ),

          // Card extra: Produtos de limpeza
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: GestureDetector(
                onTap: () => _navigate(context, const CleaningProductsPage()),
                child: Container(
                  decoration: AppTheme.cardDecoration,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.cleaning_services_rounded,
                            color: Color(0xFF4CAF50), size: 26),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Produtos de Limpeza',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary)),
                            SizedBox(height: 2),
                            Text('Guia de segurança',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.textLight),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  static void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ResourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
