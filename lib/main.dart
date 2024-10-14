import 'package:flutter/material.dart';
import 'models/health_data.dart';
import 'pages/health_dashboard.dart';
import 'pages/Profile/profile_page.dart';
import 'pages/exercise_page.dart';
import 'pages/Resources/resoucers_page.dart';
import 'pages/NearbyHospitalsPage.dart';

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

  // Calcula calorias com base nos passos
  void _calculateCalories() {
    healthData.activeCalories = healthData.steps * 0.04; // Ajuste conforme desejado
  }

  List<Widget> _pages() {
    return [
      HealthDashboard(
        healthData: healthData,
        stepGoal: stepGoal, // Passa a meta para o Dashboard
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
            stepGoal = newStepGoal; // Atualiza a meta de passos na ProfilePage
            _calculateCalories(); // Recalcula calorias ao atualizar o perfil
          });
        },
        stepGoal: stepGoal, // Passa a meta inicial para a página de perfil
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
          unselectedItemColor: Colors.redAccent,
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
