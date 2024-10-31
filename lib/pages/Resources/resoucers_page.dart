import 'package:flutter/material.dart';
import 'water_consumption_page.dart';
import 'disease_outbreaks_page.dart';
import 'menstrual_cycle_page.dart';
import 'cleaning_products_page.dart';
import 'package:asclepio/pages/Profile/profile_page.dart';

class ResourcesPage extends StatelessWidget {
  final double userWeight;
  const ResourcesPage({Key? key, required this.userWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
            return GridView.builder(
              itemCount: _resourceList(context).length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemBuilder: (context, index) {
                final resource = _resourceList(context)[index];
                return _buildResourceCard(context, resource['title'], resource['icon'], resource['onTap']);
              },
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _resourceList(BuildContext context) {
    return [
      {
        'title': 'Controle de Consumo de Água',
        'icon': Icons.local_drink,
        'onTap': () => _navigateToPage(context, WaterConsumptionPage(weight: userWeight)),
      },
      {
        'title': 'Surtos de Doenças',
        'icon': Icons.warning_amber_rounded,
        'onTap': () => _navigateToPage(context, DiseaseOutbreaksPage()),
      },
      {
        'title': 'Controle de Ciclo Menstrual',
        'icon': Icons.female,
        'onTap': () => _navigateToPage(context, MenstrualCyclePage()),
      },
      {
        'title': 'Mistura de Produtos de Limpeza',
        'icon': Icons.cleaning_services,
        'onTap': () => _navigateToPage(context, CleaningProductsPage()),
      },
    ];
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildResourceCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
