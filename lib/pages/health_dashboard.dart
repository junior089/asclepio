import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/stat_card.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asclepio/models/health_data.dart';

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
  double _distance = 0.0;
  int _activeMinutes = 0;
  double _dailyWaterIntake = 0;
  double _waterConsumed = 0;
  double _bloodOxygenLevel = 98.0;

  // Novas variáveis para pressão arterial e temperatura corporal
  String _bloodPressure = '120/80'; // valor padrão
  double _bodyTemperature = 36.5; // valor padrão

  @override
  void initState() {
    super.initState();
    _dailyWaterIntake = widget.healthData.weight * 35; // em ml
    _loadData();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      double yChange = (event.y - _lastY).abs();
      if (yChange > 1.0 && !_isStepping) {
        setState(() {
          _steps++;
          _isStepping = true;
          _distance = _steps * 0.00075;
          _activeMinutes = (_steps / 60).toInt();
          _caloriesBurned = calculateCalories();
        });
        _saveData();
      } else if (yChange < 0.5 && _isStepping) {
        _isStepping = false;
      }
      _lastY = event.y;
    });
  }

  int calculateCalories() {
    return (_steps * 0.045).toInt();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _caloriesBurned = prefs.getInt('caloriesBurned') ?? 0;
      _distance = prefs.getDouble('distance') ?? 0.0;
      _activeMinutes = prefs.getInt('activeMinutes') ?? 0;
      _waterConsumed = prefs.getDouble('waterConsumed') ?? 0;
      _bloodOxygenLevel = prefs.getDouble('bloodOxygenLevel') ?? 96.0;
      _bloodPressure = prefs.getString('bloodPressure') ?? '120/80';
      _bodyTemperature = prefs.getDouble('bodyTemperature') ?? 36.5;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('steps', _steps);
    prefs.setInt('caloriesBurned', _caloriesBurned);
    prefs.setDouble('distance', _distance);
    prefs.setInt('activeMinutes', _activeMinutes);
    prefs.setDouble('waterConsumed', _waterConsumed);
    prefs.setDouble('bloodOxygenLevel', _bloodOxygenLevel);
    prefs.setString('bloodPressure', _bloodPressure);
    prefs.setDouble('bodyTemperature', _bodyTemperature);
  }

  void _addWaterConsumption(double amount) {
    setState(() {
      _waterConsumed += amount;
    });
    _saveData();
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
              StatCard(
                title: 'Oxygen Level',
                value: '${_bloodOxygenLevel.toStringAsFixed(1)} %',
                icon: Icons.air,
                color: Colors.orange,
              ),
              StatCard(
                title: 'Blood Pressure',
                value: _bloodPressure,
                icon: Icons.monitor_heart,
                color: Colors.purple,
              ),
              StatCard(
                title: 'BD Temperature',
                value: '${_bodyTemperature.toStringAsFixed(1)} °C',
                icon: Icons.thermostat,
                color: Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

