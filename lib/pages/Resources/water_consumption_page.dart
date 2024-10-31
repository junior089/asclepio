import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WaterConsumptionPage extends StatefulWidget {
  final double weight;

  const WaterConsumptionPage({Key? key, required this.weight}) : super(key: key);

  @override
  _WaterConsumptionPageState createState() => _WaterConsumptionPageState();
}

class _WaterConsumptionPageState extends State<WaterConsumptionPage> {
  double _dailyWaterIntake = 0;
  double _waterConsumed = 0;
  List<Map<String, dynamic>> _consumptionLog = [];
  double _customAmount = 0;
  int _notificationHour = 0;
  int _notificationInterval = 2;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final int reminderInterval = 2; // Intervalo de lembrete em horas
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _calculateDailyWaterIntake();
    _loadWaterConsumptionData();
    _scheduleWaterReminders();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // O callback deve ser definido aqui
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          debugPrint('Notificação selecionada: ${response.payload}');
        }
      },
    );
  }

  void _calculateDailyWaterIntake() {
    setState(() {
      _dailyWaterIntake = widget.weight * 35;
    });
  }

  Future<void> _loadWaterConsumptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterConsumed = prefs.getDouble('waterConsumed') ?? 0;
      _consumptionLog = (prefs.getStringList('consumptionLog') ?? [])
          .map((entry) => Map<String, dynamic>.from(jsonDecode(entry)))
          .toList();
    });
  }

  Future<void> _saveWaterConsumptionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('waterConsumed', _waterConsumed);
    prefs.setStringList('consumptionLog',
        _consumptionLog.map((entry) => jsonEncode(entry)).toList());
  }

  void _addWaterConsumption(double amount) {
    setState(() {
      _waterConsumed += amount;
      _consumptionLog.add({
        'amount': amount,
        'time': DateTime.now().toIso8601String(),
      });
    });
    _saveWaterConsumptionData();
  }

  void _removeConsumption(int index) {
    setState(() {
      _waterConsumed -= _consumptionLog[index]['amount'];
      _consumptionLog.removeAt(index);
    });
    _saveWaterConsumptionData();
  }

  Future<void> _showCustomAmountDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Adicionar Água Personalizada'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Quantidade (ml)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _customAmount = double.tryParse(value) ?? 0;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                _addCustomAmount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleRegularReminders() async {
    // Agendar lembretes a cada 2 horas (ajustável conforme necessário)
    const interval = Duration(hours: 2);
    for (int i = 1; i <= 12; i++) {
      await _scheduleWaterReminder((interval * i) as int);
    }
  }

  Future<void> _scheduleWaterReminder(int hour) async {
    // Verifica se o horário é válido
    if (hour < 0 || hour > 23) return; // Hora inválida

    var scheduledTime = DateTime.now().add(Duration(hours: hour));
    var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'water_reminder_channel',
      'Water Reminder',
      channelDescription: 'Reminder to drink water',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Hora de Beber Água!',
      'Lembre-se de beber água!',
      tzScheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  Future<void> _showNotificationIntervalDialog() async {
    int? selectedInterval;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Intervalo de Notificações'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Intervalo (horas)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              selectedInterval = int.tryParse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (selectedInterval != null && selectedInterval! > 0) {
                  _notificationInterval = selectedInterval!;
                  _scheduleWaterReminders(); // Reagendar as notificações
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Método para agendar as notificações com base no intervalo definido
  Future<void> _scheduleWaterReminders() async {
    // Cancela todas as notificações agendadas antes de reprogramar
    await _flutterLocalNotificationsPlugin.cancelAll();

    for (int i = 1; i <= 5; i++) { // Exemplo: 5 lembretes
      var scheduledTime = DateTime.now().add(Duration(hours: _notificationInterval * i));
      var tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        i, // ID único para cada notificação
        'Hora de Beber Água!',
        'Lembre-se de beber água!',
        tzScheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder_channel',
            'Water Reminder',
            channelDescription: 'Reminder to drink water',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }


  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configurações de Notificação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Defina o horário para receber lembretes de beber água:'),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Hora (0-23)'),
                onChanged: (value) {
                  _notificationHour = int.tryParse(value) ?? 0; // Armazena o horário
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _scheduleWaterReminder(_notificationHour); // Usa o horário definido
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_waterConsumed / _dailyWaterIntake).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Consumo de Água'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotificationIntervalDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 130.0,
              lineWidth: 15.0,
              percent: progress,
              center: Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.blueAccent,
              backgroundColor: Colors.blue[100]!,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Meta', '${_dailyWaterIntake.toStringAsFixed(0)} ml', Icons.local_drink),
                _buildInfoCard('Consumido', '${_waterConsumed.toStringAsFixed(0)} ml', Icons.opacity),
              ],
            ),
            const SizedBox(height: 20),
            _buildAddWaterButtons(),
            const SizedBox(height: 20),
            const Text(
              'Histórico de Consumo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _consumptionLog.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_consumptionLog[index]['time']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeConsumption(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removido: ${_consumptionLog[index]['amount']} ml')),
                      );
                    },
                    child: _buildConsumptionTile(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddWaterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _addWaterConsumption(200),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('200 ml'),
        ),
        ElevatedButton(
          onPressed: () => _addWaterConsumption(500),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('500 ml'),
        ),
        ElevatedButton(
          onPressed: _showCustomAmountDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Personalizado'),
        ),
      ],
    );
  }

  Widget _buildConsumptionTile(int index) {
    return ListTile(
      title: Text('${_consumptionLog[index]['amount']} ml'),
      subtitle: Text(
        DateTime.parse(_consumptionLog[index]['time']).toString(),
      ),
      trailing: const Icon(Icons.arrow_back_ios),
    );
  }

  void _addCustomAmount() {
    if (_customAmount > 0) {
      _addWaterConsumption(_customAmount);
      _customAmount = 0;
    }
  }
}
