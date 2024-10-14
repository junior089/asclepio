import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WaterConsumptionPage extends StatefulWidget {
  final double weight;

  const WaterConsumptionPage({Key? key, required this.weight}) : super(key: key);

  @override
  _WaterConsumptionPageState createState() => _WaterConsumptionPageState();
}

class _WaterConsumptionPageState extends State<WaterConsumptionPage> {
  double _dailyWaterIntake = 0;
  double _waterConsumed = 0;
  List<double> _consumptionLog = [];

  @override
  void initState() {
    super.initState();
    _calculateDailyWaterIntake();
  }

  void _calculateDailyWaterIntake() {
    _dailyWaterIntake = widget.weight * 30;
    setState(() {});
  }

  void _addWaterConsumption(double amount) {
    setState(() {
      _waterConsumed += amount;
      _consumptionLog.add(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_waterConsumed / _dailyWaterIntake).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Consumo de Água'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 15.0,
              percent: progress,
              center: Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.blueAccent,
              backgroundColor: Colors.blue[100]!,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Meta', '${_dailyWaterIntake.toStringAsFixed(0)} ml', Icons.local_drink),
                _buildInfoCard('Consumido', '${_waterConsumed.toStringAsFixed(0)} ml', Icons.opacity),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [100, 250, 500].map((amount) => _buildAddButton(amount.toDouble())).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              'Histórico de Consumo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _consumptionLog.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.local_drink, color: Colors.blue[300]),
                    title: Text('${_consumptionLog[index].toStringAsFixed(1)} ml'),
                    subtitle: Text('Hora: ${TimeOfDay.now().format(context)}'),
                    tileColor: index % 2 == 0 ? Colors.blue[50] : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(double amount) {
    return FloatingActionButton(
      onPressed: () => _addWaterConsumption(amount),
      backgroundColor: Colors.blueAccent,
      child: Text('${amount.toInt()} ml', style: const TextStyle(fontSize: 12)),
    );
  }
}
