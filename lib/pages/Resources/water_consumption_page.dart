import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Importar para usar jsonEncode e jsonDecode

class WaterConsumptionPage extends StatefulWidget {
  final double weight;

  const WaterConsumptionPage({Key? key, required this.weight}) : super(key: key);

  @override
  _WaterConsumptionPageState createState() => _WaterConsumptionPageState();
}

class _WaterConsumptionPageState extends State<WaterConsumptionPage> {
  double _dailyWaterIntake = 0;
  double _waterConsumed = 0;
  List<Map<String, dynamic>> _consumptionLog = [];
  double _customAmount = 0;

  @override
  void initState() {
    super.initState();
    _calculateDailyWaterIntake();
    _loadWaterConsumptionData();
  }

  void _calculateDailyWaterIntake() {
    setState(() {
      _dailyWaterIntake = widget.weight * 35;
    });
  }

  Future<void> _loadWaterConsumptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterConsumed = prefs.getDouble('waterConsumed') ?? 0;
      _consumptionLog = (prefs.getStringList('consumptionLog') ?? [])
          .map((entry) => Map<String, dynamic>.from(jsonDecode(entry)))
          .toList();
    });
  }

  Future<void> _saveWaterConsumptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('waterConsumed', _waterConsumed);
    prefs.setStringList('consumptionLog',
        _consumptionLog.map((entry) => jsonEncode(entry)).toList());
  }

  void _addWaterConsumption(double amount) {
    setState(() {
      _waterConsumed += amount;
      _consumptionLog.add({
        'amount': amount,
        'time': DateTime.now().toIso8601String(), // Use ISO 8601 para armazenamento
      });
    });
    _saveWaterConsumptionData();
  }

  void _removeConsumption(int index) {
    setState(() {
      _waterConsumed -= _consumptionLog[index]['amount'];
      _consumptionLog.removeAt(index);
    });
    _saveWaterConsumptionData();
  }

  void _addCustomAmount() {
    if (_customAmount > 0) {
      _addWaterConsumption(_customAmount);
      _customAmount = 0;
    }
  }

  Future<void> _showCustomAmountDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Água Personalizada'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Quantidade (ml)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _customAmount = double.tryParse(value) ?? 0;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                _addCustomAmount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              progressColor: Colors.greenAccent,
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
            _buildAddWaterButtons(),
            const SizedBox(height: 30),
            const Text(
              'Histórico de Consumo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _consumptionLog.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_consumptionLog[index]['time']),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      _removeConsumption(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removido: ${_consumptionLog[index]['amount']} ml')),
                      );
                    },
                    child: _buildConsumptionTile(index),
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

  Widget _buildAddWaterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAddButton(100),
        _buildAddButton(250),
        _buildAddButton(500),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
          onPressed: _showCustomAmountDialog,
        ),
      ],
    );
  }

  Widget _buildAddButton(double amount) {
    return FloatingActionButton(
      onPressed: () => _addWaterConsumption(amount),
      backgroundColor: Colors.blueAccent,
      child: Text('${amount.toInt()} ml', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildConsumptionTile(int index) {
    return ListTile(
      leading: Icon(Icons.local_drink, color: Colors.blue[300]),
      title: Text('${_consumptionLog[index]['amount'].toStringAsFixed(1)} ml'),
      subtitle: Text('Hora: ${DateTime.parse(_consumptionLog[index]['time']).toLocal().toString().split(' ')[1].split('.')[0]}'),
      tileColor: index % 2 == 0 ? Colors.blue[50] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
