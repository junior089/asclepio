import 'package:flutter/material.dart';

class ExerciseHistory extends StatelessWidget {
  final List<Map<String, dynamic>> exerciseHistory;

  ExerciseHistory({required this.exerciseHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Exercícios")),
      body: ListView.builder(
        itemCount: exerciseHistory.length,
        itemBuilder: (context, index) {
          final exercise = exerciseHistory[index];
          return ListTile(
            leading: Icon(exercise['icon'], color: exercise['color']),
            title: Text(exercise['name']),
            subtitle: Text(
              'Duração: ${exercise['duration']} min\nData: ${exercise['date']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        },
      ),
    );
  }
}

