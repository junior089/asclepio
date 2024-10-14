import 'package:asclepio/pages/Profile/avatar_selection_page.dart';
import 'package:flutter/material.dart';
import '../resources/resoucers_page.dart';
import 'weight_chart.dart';
import 'symptoms_history.dart';
import 'exercise_history.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final int userAge;
  final double weight;
  final double height;
  final int stepGoal;
  final Function(String, int, double, double, int) onProfileUpdated;

  const ProfilePage({
    Key? key,
    required this.userName,
    required this.userAge,
    required this.weight,
    required this.height,
    required this.stepGoal,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController stepGoalController;
  late TextEditingController newWeightController;

  String _selectedAvatar = 'assets/avatars/avatar1.png';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _symptomsHistory = [];
  List<double> weightHistory = []; // Lista para armazenar o histórico de pesos

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    nameController = TextEditingController(text: widget.userName);
    ageController = TextEditingController(text: widget.userAge.toString());
    weightController = TextEditingController(text: widget.weight.toString());
    heightController = TextEditingController(text: widget.height.toString());
    stepGoalController = TextEditingController(text: widget.stepGoal.toString());
    newWeightController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    stepGoalController.dispose();
    newWeightController.dispose();
    super.dispose();
  }

  void _showEditDialog(String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
            keyboardType: title == "Idade" || title == "Meta de Passos" ? TextInputType.number : TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _updateProfileData(title, controller.text);
                } else {
                  _showSnackBar("O campo não pode estar vazio!");
                }
              },
              child: const Text("Salvar"),
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

  void _updateProfileData(String title, String value) {
    switch (title) {
      case "Nome":
        nameController.text = value;
        break;
      case "Idade":
        ageController.text = value;
        break;
      case "Peso (kg)":
        weightController.text = value;
        double? newWeight = double.tryParse(value);
        if (newWeight != null) {
          weightHistory.add(newWeight); // Adiciona o novo peso ao histórico
        }
        break;
      case "Altura (m)":
        heightController.text = value;
        break;
      case "Meta de Passos":
        stepGoalController.text = value;
        break;
    }

    widget.onProfileUpdated(
      nameController.text,
      int.tryParse(ageController.text) ?? widget.userAge,
      double.tryParse(weightController.text) ?? widget.weight,
      double.tryParse(heightController.text) ?? widget.height,
      int.tryParse(stepGoalController.text) ?? widget.stepGoal,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _navigateToAvatarSelection() async {
    final selectedAvatar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvatarSelectionPage()),
    );

    if (selectedAvatar != null) {
      setState(() => _selectedAvatar = selectedAvatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _updateProfileData("Nome", nameController.text),
          ),
          IconButton(
            icon: const Icon(Icons.apps),
            onPressed: _navigateToResourcesPage,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.black,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: "Informações"),
            Tab(icon: Icon(Icons.fitness_center), text: "Gráfico de Peso"),
            Tab(icon: Icon(Icons.bar_chart), text: "Histórico de Sintomas"),
            Tab(icon: Icon(Icons.history), text: "Histórico de Exercício"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          WeightChart(weightData: weightHistory), // Passa a lista de pesos
          SymptomsHistory(symptomsHistory: _symptomsHistory, addSymptom: _addSymptom), // Passar o histórico e a função
          ExerciseHistory(), // Histórico de exercícios
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _navigateToAvatarSelection,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(_selectedAvatar),
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileCard("Nome", nameController.text, Icons.person),
          _buildProfileCard("Idade", "${ageController.text} anos", Icons.calendar_today),
          _buildProfileCard("Peso (kg)", "${weightController.text} kg", Icons.fitness_center),
          _buildProfileCard("Altura (m)", "${heightController.text} m", Icons.height),
          _buildProfileCard("Meta de Passos", stepGoalController.text, Icons.directions_walk),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String title, String value, IconData icon) {
    return GestureDetector(
      onTap: () => _showEditDialog(title, _getControllerForTitle(title)),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
              Text(value, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController _getControllerForTitle(String title) {
    switch (title) {
      case "Nome":
        return nameController;
      case "Idade":
        return ageController;
      case "Peso (kg)":
        return weightController;
      case "Altura (m)":
        return heightController;
      case "Meta de Passos":
        return stepGoalController;
      default:
        return TextEditingController();
    }
  }

  void _addSymptom(String symptom) {
    if (symptom.isNotEmpty) {
      final timestamp = DateTime.now().toString();
      _symptomsHistory.add({"symptom": symptom, "timestamp": timestamp});
      setState(() {});
    }
  }

  void _navigateToResourcesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResourcesPage(userWeight: widget.weight),
      ),
    );
  }
}
