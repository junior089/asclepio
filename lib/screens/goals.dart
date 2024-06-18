import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> goals = [
    Goal(title: 'Meta de Passos Diária', value: '10000', color: Colors.red),
    Goal(title: 'Meta de Leitura Semanal', value: '5 livros', color: Colors.blue),
    Goal(title: 'Meta de Economia Mensal', value: 'R\$ 1000', color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return GoalCard(
                    goal: goals[index],
                    onEdit: () => _editGoal(index),
                    onRemove: () => _removeGoal(index),
                    onToggleCompletion: () => _toggleCompletion(index),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addGoal,
              child: Text('Adicionar Meta'),
            ),
          ],
        ),
      ),
    );
  }

  void _addGoal() {
    setState(() {
      goals.add(Goal(title: 'Nova Meta', value: 'Novo valor', color: Colors.green));
    });
  }

  void _editGoal(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        controller.text = goals[index].title;
        return AlertDialog(
          title: Text('Editar Meta'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nome da Meta'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goals[index].title = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removeGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      goals[index].completed = !goals[index].completed;
    });
  }
}

class Goal {
  String title;
  String value;
  Color color;
  bool completed;

  Goal({
    required this.title,
    required this.value,
    required this.color,
    this.completed = false,
  });
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onToggleCompletion;

  GoalCard({
    required this.goal,
    required this.onEdit,
    required this.onRemove,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    goal.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Checkbox(
                  value: goal.completed,
                  onChanged: (newValue) => onToggleCompletion(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              goal.value,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: goal.color,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  child: Text('Editar Meta'),
                ),
                ElevatedButton(
                  onPressed: onRemove,
                  child: Text('Remover Meta'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
