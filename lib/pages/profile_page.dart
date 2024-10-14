import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:asclepio/pages/avatar_selection_page.dart';
import 'resources/resoucers_page.dart';

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
  List<FlSpot> _weightSpots = [];
  List<Map<String, String>> _symptomsHistory = [];

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

  double calculateBMI() {
    final weight = double.tryParse(weightController.text) ?? widget.weight;
    final height = double.tryParse(heightController.text) ?? widget.height;
    return weight / (height * height);
  }

  String getBMICategory() {
    final bmi = calculateBMI();
    if (bmi < 18.5) return "Abaixo do Peso";
    if (bmi < 24.9) return "Peso Normal";
    if (bmi < 29.9) return "Sobrepeso";
    return "Obesidade";
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

  void _updateWeightSpots() {
    final newWeight = double.tryParse(newWeightController.text);
    if (newWeight != null) {
      final x = _weightSpots.length + 1;
      _weightSpots.add(FlSpot(x.toDouble(), newWeight));
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final bmi = calculateBMI();
    final bmiCategory = getBMICategory();

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
            onPressed: _navigateToResourcesPage, // Navegar para a página de recursos
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
          _buildProfileTab(bmi, bmiCategory),
          _buildWeightChart(),
          _buildSymptomsHistory(),
          _buildExerciseHistory(),
        ],
      ),
    );
  }

  Widget _buildProfileTab(double bmi, String bmiCategory) {
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
          _buildProfileCard("IMC", "${bmi.toStringAsFixed(1)} - $bmiCategory", Icons.health_and_safety),
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

  Widget _buildWeightChart() {
    return Column(
      children: [
        const Text("Adicione um Novo Peso"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: newWeightController,
            decoration: const InputDecoration(labelText: "Peso"),
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: _updateWeightSpots,
          child: const Text("Adicionar"),
        ),
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _weightSpots,
                  isCurved: true,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsHistory() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(labelText: "Sintoma"),
            onSubmitted: _addSymptom,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _symptomsHistory.length,
            itemBuilder: (context, index) {
              final symptom = _symptomsHistory[index];
              return ListTile(
                title: Text(symptom['symptom']!),
                subtitle: Text(symptom['timestamp']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseHistory() {
    return const Center(child: Text("Histórico de Exercício"));
  }
}
