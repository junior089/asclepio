import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/health_data.dart';
import '../widgets/stat_card.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HealthDashboard extends StatefulWidget {
  final HealthData healthData;
  final int stepGoal;

  const HealthDashboard({
    Key? key,
    required this.healthData,
    required this.stepGoal,
  }) : super(key: key);

  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  int _steps = 0;
  double _lastY = 0.0;
  bool _isStepping = false;
  int _caloriesBurned = 0;
  double _distance = 0.0; // Distância percorrida
  int _activeMinutes = 0; // Minutos de atividade

  // Adicione essas variáveis para controlar o consumo de água
  double _dailyWaterIntake = 0;
  double _waterConsumed = 0;

  @override
  void initState() {
    super.initState();
    // Calcular a meta diária de ingestão de água (exemplo: peso * 30)
    _dailyWaterIntake = widget.healthData.weight * 30; // em ml

    gyroscopeEvents.listen((GyroscopeEvent event) {
      double yChange = (event.y - _lastY).abs();
      if (yChange > 1.0 && !_isStepping) {
        setState(() {
          _steps++;
          _isStepping = true;
          _distance = _steps * 0.00075; // Convertendo passos para km
          _activeMinutes = (_steps / 60).toInt();
          _caloriesBurned = calculateCalories();
        });
      } else if (yChange < 0.5 && _isStepping) {
        _isStepping = false;
      }
      _lastY = event.y;
    });
  }

  int calculateCalories() {
    return (_steps * 0.045).toInt(); // Estimativa de calorias por passo
  }

  @override
  Widget build(BuildContext context) {
    double progress = _steps / widget.stepGoal;
    double waterProgress = (_waterConsumed / _dailyWaterIntake).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 15.0,
            percent: progress > 1.0 ? 1.0 : progress,
            animation: true,
            animationDuration: 1200,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text("Steps", style: TextStyle(fontSize: 16)),
              ],
            ),
            progressColor: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              StatCard(
                title: 'Calories',
                value: '$_caloriesBurned kcal',
                icon: Icons.local_fire_department,
                color: Colors.red,
              ),
              StatCard(
                title: 'Steps',
                value: '$_steps passos',
                icon: Icons.directions_run,
                color: Colors.blue,
              ),
              StatCard(
                title: 'Distance',
                value: '$_distance km',
                icon: Icons.directions_walk,
                color: Colors.green,
              ),
              StatCard(
                title: 'Weight',
                value: '${widget.healthData.weight} kg',
                icon: Icons.fitness_center,
                color: Colors.cyan,
              ),
              StatCard(
                title: 'Heart Rate',
                value: '${widget.healthData.heartRate} bpm',
                icon: Icons.favorite,
                color: Colors.pink,
              ),
              StatCard(
                title: 'Water Intake',
                value: '${_waterConsumed.toStringAsFixed(1)} ml / ${_dailyWaterIntake.toStringAsFixed(1)} ml',
                icon: Icons.local_drink,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
