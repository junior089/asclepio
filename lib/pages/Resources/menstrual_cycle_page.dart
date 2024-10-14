import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenstrualCyclePage extends StatefulWidget {
  const MenstrualCyclePage({Key? key}) : super(key: key);

  @override
  _MenstrualCyclePageState createState() => _MenstrualCyclePageState();
}

class _MenstrualCyclePageState extends State<MenstrualCyclePage> {
  DateTime? _cycleStartDate; // Data de início do ciclo
  final int _cycleLength = 28; // Duração média do ciclo
  final List<String> _symptoms = []; // Lista de sintomas
  final TextEditingController _symptomController = TextEditingController();

  // Método para calcular a próxima menstruação
  DateTime get _nextPeriodDate => (_cycleStartDate ?? DateTime.now()).add(Duration(days: _cycleLength));

  // Método para registrar um sintoma
  void _addSymptom() {
    if (_symptomController.text.isNotEmpty) {
      setState(() {
        _symptoms.add(_symptomController.text);
        _symptomController.clear();
      });
    }
  }

  // Método para selecionar a data do início do ciclo
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _cycleStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _cycleStartDate) {
      setState(() {
        _cycleStartDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildDateHeader(),
            const SizedBox(height: 20),
            _buildCycleStatus(),
            const SizedBox(height: 20),
            _buildContentSection(),
            const SizedBox(height: 20),
            _buildSymptomInput(),
            const SizedBox(height: 20),
            _buildSymptomList(),
            const Spacer(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          return Column(
            children: [
              Text(
                ["S", "T", "Q", "HOJE", "Q", "S", "D"][index],
                style: TextStyle(
                  fontWeight: index == 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                (DateTime.now().day + index).toString(),
                style: TextStyle(
                  color: index >= 5 ? Colors.pink : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCycleStatus() {
    final daysUntilNextPeriod = _nextPeriodDate.difference(DateTime.now()).inDays;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Menstruação em',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            '$daysUntilNextPeriod dias',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _selectStartDate(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Definir data do ciclo'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meu conteúdo diário · Hoje',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildContentCard('Dia do ciclo', '${DateTime.now().day}', Colors.purple[100]!),
              _buildContentCard('Sintomas', '${_symptoms.length}', Colors.blue[100]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String subtitle, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                labelText: 'Adicionar sintoma',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSymptom,
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sintomas registrados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._symptoms.map((symptom) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(symptom, style: const TextStyle(fontSize: 16)),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Hoje',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Conteúdo',
        ),
      ],
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.grey,
    );
  }
}
