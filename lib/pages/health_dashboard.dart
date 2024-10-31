import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/stat_card.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asclepio/models/health_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:http/http.dart' as http;

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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [fitness.FitnessApi.fitnessActivityReadScope],
  );

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Solicitar permissões
    _dailyWaterIntake = widget.healthData.weight * 35; // em ml
    _loadData();
  }

  Future<void> _requestPermissions() async {
    await Permission.activityRecognition.request();
    await Permission.sensors.request();
  }

  Future<void> _initializeGoogleFitData() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      // O usuário não fez login
      return;
    }

    final authHeaders = await account.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    final fitnessApi = fitness.FitnessApi(httpClient);

    final now = DateTime.now();
    final startTimeMillis = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch.toString();
    final endTimeMillis = now.millisecondsSinceEpoch.toString();

    // Utilize datasets.get em vez de aggregate
    final stepsDataSource = await fitnessApi.users.dataSources.datasets.get(
      "me",
      "com.google.step_count.delta", // ID da fonte de dados
      "$startTimeMillis-$endTimeMillis", // Intervalo de tempo
    );

    int steps = 0;
    if (stepsDataSource.point != null) {
      for (var point in stepsDataSource.point!) {
        // Convertendo num para int
        steps += (point.value?.first.intVal ?? 0).toInt();
      }
    }

    setState(() {
      _steps = steps;
      _distance = _steps * 0.00075; // Exemplo: 0,75 metros por passo
      _activeMinutes = (_steps / 60).toInt();
      _caloriesBurned = calculateCalories();
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
        padding: const EdgeInsets.all(9.0),
        children: [
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 12.0,
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
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
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
                title: 'B Temperature',
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

  @override
  void dispose() {
    _saveData();
    super.dispose();
  }
}

// Implementação do cliente HTTP do Google
class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;

  GoogleHttpClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return request.send();
  }
}
