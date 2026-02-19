import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_theme.dart';

class SymptomsHistory extends StatelessWidget {
  const SymptomsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final symptoms = provider.symptomsHistory;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Histórico de Sintomas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddSymptomDialog(context, provider),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Adicionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: symptoms.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.healing_outlined,
                                size: 56, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('Nenhum sintoma registrado.',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: symptoms.length,
                        itemBuilder: (context, index) {
                          final entry = symptoms[index];
                          final symptom = entry['symptom'] ?? '';
                          final timestamp = entry['timestamp'] ?? '';
                          DateTime? date;
                          try {
                            date = DateTime.parse(timestamp);
                          } catch (_) {}

                          return Dismissible(
                            key: Key('$symptom-$timestamp'),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              provider.removeSymptom(index);
                              Fluttertoast.showToast(msg: 'Sintoma removido');
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.sick_outlined,
                                      color: Colors.red),
                                ),
                                title: Text(symptom,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  date != null
                                      ? DateFormat('dd/MM/yyyy HH:mm')
                                          .format(date)
                                      : timestamp,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12),
                                ),
                                trailing: const Icon(Icons.swipe_left,
                                    size: 16, color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddSymptomDialog(BuildContext context, AppProvider provider) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adicionar Sintoma'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Descreva o sintoma'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                provider.addSymptom(text);
                Navigator.pop(ctx);
              } else {
                Fluttertoast.showToast(msg: 'O sintoma não pode estar vazio.');
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
