import 'package:flutter/material.dart';
import 'pages/health_dashboard.dart';
import 'pages/Profile/profile_page.dart';
import 'pages/exercise_page.dart';
import 'pages/Resources/resoucers_page.dart';
import 'pages/NearbyHospitalsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asclepio/models/health_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final HealthData healthData = HealthData(
    activeCalories: 300,
    activityMinutes: 30,
    hoursActive: 12,
    steps: 6000,
    totalSteps: 10000,
    distance: 6.7,
    tasksCompleted: 8,
    weight: 64.2,
    heartRate: 75,
  );

  String userName = "João Silva";
  int userAge = 25;
  double userHeight = 1.75;
  int stepGoal = 10000; // Define o valor inicial da meta de passos

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Função para carregar dados do Shared Preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "João Silva";
      userAge = prefs.getInt('userAge') ?? 25;
      userHeight = prefs.getDouble('userHeight') ?? 1.75;
      healthData.weight = prefs.getDouble('userWeight') ?? 64.2;
      stepGoal = prefs.getInt('stepGoal') ?? 10000;
    });
  }

  // Função para salvar dados no Shared Preferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setInt('userAge', userAge);
    await prefs.setDouble('userHeight', userHeight);
    await prefs.setDouble('userWeight', healthData.weight);
    await prefs.setInt('stepGoal', stepGoal);
  }

  // Calcula calorias com base nos passos
  void _calculateCalories() {
    healthData.activeCalories = healthData.steps * 0.04;
  }

  List<Widget> _pages() {
    return [
      HealthDashboard(
        healthData: healthData,
        stepGoal: stepGoal,
      ),
      const ExercisePage(),
      ResourcesPage(userWeight: healthData.weight),
      NearbyHospitalsPage(),
      ProfilePage(
        userName: userName,
        userAge: userAge,
        weight: healthData.weight,
        height: userHeight,
        onProfileUpdated: (String name, int age, double weight, double height, int newStepGoal) {
          setState(() {
            userName = name;
            userAge = age;
            healthData.weight = weight;
            userHeight = height;
            stepGoal = newStepGoal;
            _calculateCalories();
            _saveUserData(); // Salva os dados após a atualização do perfil
          });
        },
        stepGoal: stepGoal,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages()[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.deepOrange,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Exercícios'),
            BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Recursos'),
            BottomNavigationBarItem(icon: Icon(Icons.local_hospital_outlined), label: 'Nearby'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
