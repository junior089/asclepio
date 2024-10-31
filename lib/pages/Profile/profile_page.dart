import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:asclepio/pages/Profile/avatar_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/resoucers_page.dart';
import 'weight_chart.dart';
import 'symptoms_history.dart';
import 'exercise_history.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
  late TextEditingController bloodTypeController;
  late TextEditingController preExistingConditionsController;
  List<String> symptomsHistory = [];
  List<String> preExistingConditions = [];
  double totalWaterConsumption = 0;


  String _selectedAvatar = 'assets/avatars/avatar2.png';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _symptomsHistory = [];
  List<double> weightHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    nameController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    stepGoalController = TextEditingController();
    newWeightController = TextEditingController();
    bloodTypeController = TextEditingController();
    preExistingConditionsController = TextEditingController();

    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('userName') ?? widget.userName;
      ageController.text = (prefs.getInt('userAge') ?? widget.userAge).toString();
      weightController.text = (prefs.getDouble('weight') ?? widget.weight).toString();
      heightController.text = (prefs.getDouble('height') ?? widget.height).toString();
      stepGoalController.text = (prefs.getInt('stepGoal') ?? widget.stepGoal).toString();
      bloodTypeController.text = prefs.getString('bloodType') ?? "O+";
      preExistingConditionsController.text = prefs.getString('preExistingConditions') ?? "";
      symptomsHistory = prefs.getStringList('symptomsHistory') ?? []; // Carregar histórico de sintomas
      totalWaterConsumption = prefs.getDouble('totalWaterConsumption') ?? 0;
    });
  }

  double _calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? widget.weight;
    double height = double.tryParse(heightController.text) ?? widget.height;
    return height > 0 ? weight / (height * height) : 0.0;
  }

  double _calculateAverageWaterConsumption() {
    return symptomsHistory.length > 0 ? totalWaterConsumption / symptomsHistory.length : 0;
  }


  Future<void> _generateUserProfilePdf() async {
    try {
      // Solicitar permissão de armazenamento
      var status = await Permission.videos.request();
      if (!status.isGranted) {
        _showSnackBar("Permissão de armazenamento negada.");
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título do prontuário
              pw.Center(
                child: pw.Text(
                  "Prontuário do Usuário",
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#2C3E50"), // Cor mais escura para o título
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 3, color: PdfColor.fromHex("#EAEDED")), // Divider mais grosso e com cor suave
              pw.SizedBox(height: 20),

              // Seção de informações pessoais
              pw.Text(
                "Informações Pessoais",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex("#2980B9"), // Azul para destacar
                ),
              ),
              pw.SizedBox(height: 15),
              _buildUserInfoRow("Nome", nameController.text),
              _buildUserInfoRow("Idade", "${ageController.text} anos"),
              _buildUserInfoRow("Peso", "${weightController.text} kg"),
              _buildUserInfoRow("Altura", "${heightController.text} m"),
              _buildUserInfoRow("IMC", _calculateBMI().toStringAsFixed(2)),
              _buildUserInfoRow("Tipo Sanguíneo", bloodTypeController.text),
              _buildUserInfoRow("Doenças Preexistentes", preExistingConditions.join(", ")),
              pw.SizedBox(height: 15),
              pw.Divider(thickness: 2, color: PdfColor.fromHex("#EAEDED")),
              pw.SizedBox(height: 15),

              // Seção de dados de atividade
              pw.Text(
                "Dados de Atividade",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex("#2980B9"),
                ),
              ),
              pw.SizedBox(height: 15),
              _buildUserInfoRow("Meta de Passos", "${stepGoalController.text} passos"),
              _buildUserInfoRow("Histórico de Peso", weightHistory.join(", ")),
              _buildUserInfoRow("Média Consumo de Água", "${_calculateAverageWaterConsumption()} L"),
              pw.SizedBox(height: 30), // Espaço no final

            ],
          ),
        ),
      );

      final directory = await getApplicationDocumentsDirectory(); // Mantenha essa linha
      final filePath = "${directory?.path}/prontuario_usuario.pdf";

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      _showSnackBar("PDF gerado com sucesso: $filePath");

      // Abrir o PDF automaticamente
      await OpenFile.open(filePath);
    } catch (e) {
      _showSnackBar("Erro ao gerar PDF: $e. Por favor, tente novamente.");
    }
  }

  pw.Widget _buildUserInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', nameController.text);
    await prefs.setInt('userAge', int.tryParse(ageController.text) ?? widget.userAge);
    await prefs.setDouble('weight', double.tryParse(weightController.text) ?? widget.weight);
    await prefs.setDouble('height', double.tryParse(heightController.text) ?? widget.height);
    await prefs.setInt('stepGoal', int.tryParse(stepGoalController.text) ?? widget.stepGoal);
    await prefs.setString('bloodType',bloodTypeController.text);
    await prefs.setString('preExistingConditions', preExistingConditionsController.text);
    await prefs.setStringList('weightHistory', weightHistory.map((e) => e.toString()).toList()); // Salvar histórico de peso
    await prefs.setStringList('symptomsHistory', symptomsHistory); // Salvar histórico de sintomas
    await prefs.setDouble('totalWaterConsumption', totalWaterConsumption); // Salvar total de água

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
    bloodTypeController.dispose();
    preExistingConditionsController.dispose();
    super.dispose();
  }

  void _addPreExistingCondition() {
    if (preExistingConditionsController.text.isNotEmpty) {
      setState(() {
        preExistingConditions.add(preExistingConditionsController.text);
        preExistingConditionsController.clear();
      });
      _saveProfileData();
    } else {
      _showSnackBar("O campo não pode estar vazio!");
    }
  }

  void _showAddConditionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Doença Pré-Existente"),
          content: TextField(
            controller: preExistingConditionsController,
            decoration: InputDecoration(labelText: "Nome da Doença"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addPreExistingCondition();
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

      case "Doenças Preexistentes":
        preExistingConditionsController.text = value; // Atualiza doenças
        break;
    }

    _saveProfileData(); // Salva os dados após qualquer atualização
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
            icon: const Icon(Icons.picture_as_pdf), // Botão para gerar PDF
            onPressed: _generateUserProfilePdf,
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
          ExerciseHistory(exerciseHistory: [],),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddConditionDialog,
        tooltip: 'Adicionar Doença',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              _buildProfileCard("IMC", _calculateBMI().toStringAsFixed(2), Icons.assessment),
              _buildProfileCard("Tipo Sanguíneo", bloodTypeController.text, Icons.bloodtype),
              _buildProfileCard("Meta de Passos", stepGoalController.text, Icons.directions_walk),
              Text(
                "Doenças Pré-Existentes:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // cor do texto
                ),
              ),
              const SizedBox(height: 10),
              ...preExistingConditions.map((condition) {
                return Card(
                  elevation: 2, // sombra para o card
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.blue), // ícone da condição
                    title: Text(
                      condition,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        )
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

  void _navigateToResourcesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResourcesPage(userWeight: double.tryParse(weightController.text) ?? 0),
      ),
    );
  }

  void _addSymptom(String symptom, DateTime date) {
    setState(() => _symptomsHistory.add({"symptom": symptom, "date": date.toString()}));
  }
}
