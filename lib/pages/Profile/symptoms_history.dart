import 'package:flutter/material.dart';

class SymptomsHistory extends StatelessWidget {
  final List<Map<String, String>> symptomsHistory;
  final Function(String) addSymptom;

  const SymptomsHistory({Key? key, required this.symptomsHistory, required this.addSymptom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Histórico de Sintomas"),
        ElevatedButton(
          onPressed: () => _showAddSymptomDialog(context),
          child: const Text("Adicionar Sintoma"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: symptomsHistory.length,
            itemBuilder: (context, index) {
              final symptomEntry = symptomsHistory[index];
              return ListTile(
                title: Text(symptomEntry['symptom']!),
                subtitle: Text(symptomEntry['timestamp']!),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddSymptomDialog(BuildContext context) {
    final TextEditingController symptomController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar Sintoma"),
          content: TextField(
            controller: symptomController,
            decoration: const InputDecoration(labelText: "Sintoma"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addSymptom(symptomController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Adicionar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
