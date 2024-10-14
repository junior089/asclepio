import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Certifique-se de adicionar o pacote de vibração no pubspec.yaml

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final List<Map<String, dynamic>> exercises = [
    {'name': 'Caminhada', 'duration': 30, 'icon': Icons.directions_walk, 'color': Colors.blue[300], 'type': 'Cardio'},
    {'name': 'Corrida', 'duration': 20, 'icon': Icons.run_circle, 'color': Colors.orange[300], 'type': 'Cardio'},
    {'name': 'Ciclismo', 'duration': 45, 'icon': Icons.directions_bike, 'color': Colors.green[300], 'type': 'Cardio'},
    {'name': 'Yoga', 'duration': 60, 'icon': Icons.self_improvement, 'color': Colors.purple[300], 'type': 'Flexibilidade'},
    {'name': 'Musculação', 'duration': 30, 'icon': Icons.fitness_center, 'color': Colors.red[300], 'type': 'Força'},
    {'name': 'Natação', 'duration': 25, 'icon': Icons.pool, 'color': Colors.teal[300], 'type': 'Cardio'},
    {'name': 'Alongamento', 'duration': 15, 'icon': Icons.straighten, 'color': Colors.pink[300], 'type': 'Flexibilidade'},
    {'name': 'HIIT', 'duration': 20, 'icon': Icons.flash_on, 'color': Colors.yellow[300], 'type': 'Cardio'},
    {'name': 'Pilates', 'duration': 30, 'icon': Icons.spa, 'color': Colors.cyan[300], 'type': 'Flexibilidade'},
    {'name': 'Escalada', 'duration': 60, 'icon': Icons.terrain, 'color': Colors.brown[300], 'type': 'Força'},
  ];

  String selectedType = 'Todos';
  final List<String> exerciseTypes = ['Todos', 'Cardio', 'Força', 'Flexibilidade'];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  IconData selectedIcon = Icons.directions_walk;
  Color selectedColor = Colors.blue[300]!; // Default color
  String selectedCategory = 'Cardio';

  @override
  Widget build(BuildContext context) {
    final filteredExercises = exercises.where((exercise) {
      final matchesType = selectedType == 'Todos' || exercise['type'] == selectedType;
      final matchesSearch = exercise['name'].toLowerCase().contains(searchController.text.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddExerciseDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Pesquisar...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                  items: exerciseTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  underline: Container(),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: filteredExercises.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailPage(exercise: exercise),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: exercise['color'],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(exercise['icon'], size: 50, color: Colors.white),
                          const SizedBox(height: 10),
                          Text(
                            exercise['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${exercise['duration']} min',
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Exercício'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome do Exercício'),
                ),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duração (min)'),
                ),
                DropdownButton<IconData>(
                  value: selectedIcon,
                  items: [
                    Icons.directions_walk,
                    Icons.run_circle,
                    Icons.directions_bike,
                    Icons.self_improvement,
                    Icons.fitness_center,
                    Icons.pool,
                    Icons.straighten,
                    Icons.flash_on,
                    Icons.spa,
                    Icons.terrain,
                  ].map((icon) {
                    return DropdownMenuItem(
                      value: icon,
                      child: Row(
                        children: [
                          Icon(icon),
                          const SizedBox(width: 8),
                          Text(icon.toString().split('.').last),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedIcon = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButton<Color>(
                  value: selectedColor,
                  items: [
                    Colors.blue[300],
                    Colors.orange[300],
                    Colors.green[300],
                    Colors.purple[300],
                    Colors.red[300],
                    Colors.teal[300],
                    Colors.pink[300],
                    Colors.yellow[300],
                    Colors.cyan[300],
                    Colors.brown[300],
                  ].map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Container(
                        height: 20,
                        width: 20,
                        color: color,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedColor = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: exerciseTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                _addExercise();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addExercise() {
    final String name = nameController.text;
    final String durationText = durationController.text;

    if (name.isNotEmpty && durationText.isNotEmpty) {
      final int duration = int.tryParse(durationText) ?? 30; // Default to 30 if parsing fails

      setState(() {
        exercises.add({
          'name': name,
          'duration': duration,
          'icon': selectedIcon,
          'color': selectedColor,
          'type': selectedCategory,
        });
      });

      nameController.clear();
      durationController.clear();
    }
  }
}

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailPage({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late int remainingTime;
  Timer? timer;
  bool isTimerRunning = false;
  late int duration;

  @override
  void initState() {
    super.initState();
    duration = widget.exercise['duration'];
    remainingTime = duration * 60; // Em segundos
  }

  void startTimer() {
    if (isTimerRunning) return;
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          isTimerRunning = false;
          Vibration.vibrate(duration: 500); // Vibra ao final do tempo
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false;
      timer?.cancel();
    });
  }

  void resetTimer() {
    setState(() {
      remainingTime = duration * 60;
      isTimerRunning = false;
      timer?.cancel();
    });
  }

  void pauseTimer() {
    setState(() {
      isTimerRunning = false;
      timer?.cancel();
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void increaseDuration() {
    setState(() {
      duration++;
      remainingTime = duration * 60; // Atualiza o tempo restante
    });
  }

  void decreaseDuration() {
    setState(() {
      if (duration > 1) {
        duration--;
        remainingTime = duration * 60; // Atualiza o tempo restante
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise['name']),
        backgroundColor: widget.exercise['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.exercise['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    value: remainingTime / (duration * 60),
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(formatTime(remainingTime), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: decreaseDuration,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: increaseDuration,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isTimerRunning ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: isTimerRunning ? stopTimer : startTimer,
                        child: Text(isTimerRunning ? 'Parar' : 'Iniciar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: resetTimer,
                        child: const Text('Resetar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: pauseTimer,
                        child: const Text('Pausar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Dica: Mantenha uma boa postura durante o exercício.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExercisePage(),
  ));
}
