import 'package:flutter/material.dart';
import 'water_consumption_page.dart';
import 'disease_outbreaks_page.dart';
import 'menstrual_cycle_page.dart'; // Importa a nova página de controle de ciclo menstrual
import 'cleaning_products_page.dart'; // Importa a nova página sobre produtos de limpeza
import 'package:asclepio/pages/Profile/profile_page.dart';

class ResourcesPage extends StatelessWidget {
  final double userWeight; // Adicione o campo para o peso do usuário
  const ResourcesPage({Key? key, required this.userWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _buildResourceCard(
              context,
              'Controle de Consumo de Água',
              Icons.local_drink,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaterConsumptionPage(weight: userWeight), // Passe o peso do usuário
                  ),
                );
              },
            ),
            _buildResourceCard(
              context,
              'Surtos de Doenças',
              Icons.warning,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiseaseOutbreaksPage(),
                  ),
                );
              },
            ),
            _buildResourceCard(
              context,
              'Controle de Ciclo Menstrual',
              Icons.woman,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenstrualCyclePage(), // Nova página para controle de ciclo
                  ),
                );
              },
            ),
            _buildResourceCard(
              context,
              'Mistura de Produtos de Limpeza',
              Icons.cleaning_services,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CleaningProductsPage(), // Nova página sobre produtos de limpeza
                  ),
                );
              },
            ),
            // Adicione mais cartões conforme necessário
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
              SizedBox(height: 8.0),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
