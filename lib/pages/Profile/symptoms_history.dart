import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SymptomsHistory extends StatefulWidget {
  final List<Map<String, String>> symptomsHistory;
  final Function(String) addSymptom;

  const SymptomsHistory({
    Key? key,
    required this.symptomsHistory,
    required this.addSymptom,
  }) : super(key: key);

  @override
  _SymptomsHistoryState createState() => _SymptomsHistoryState();
}

class _SymptomsHistoryState extends State<SymptomsHistory> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Histórico de Sintomas",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _showAddSymptomDialog(context),
            child: const Text("Adicionar Sintoma"),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.symptomsHistory.length,
              itemBuilder: (context, index) {
                final symptomEntry = widget.symptomsHistory[index];
                return Dismissible(
                  key: Key(symptomEntry['timestamp']!),
                  onDismissed: (direction) {
                    setState(() {
                      widget.symptomsHistory.removeAt(index);
                      Fluttertoast.showToast(
                        msg: "Sintoma removido",
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          symptomEntry['symptom']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(
                            DateTime.parse(symptomEntry['timestamp']!),
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            // Implementar ação para exibir mais informações sobre o sintoma.
                            _showSymptomDetails(symptomEntry);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
                final symptomText = symptomController.text.trim();
                if (symptomText.isNotEmpty) {
                  widget.addSymptom(symptomText);
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                    msg: "O sintoma não pode estar vazio.",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
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

  void _showSymptomDetails(Map<String, String> symptomEntry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detalhes do Sintoma"),
          content: Text(
            'Sintoma: ${symptomEntry['symptom']}\n'
                'Registrado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(symptomEntry['timestamp']!))}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
