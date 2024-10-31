import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenstrualCyclePage extends StatefulWidget {
  const MenstrualCyclePage({Key? key}) : super(key: key);

  @override
  _MenstrualCyclePageState createState() => _MenstrualCyclePageState();
}

class _MenstrualCyclePageState extends State<MenstrualCyclePage> with SingleTickerProviderStateMixin {
  DateTime? _cycleStartDate;
  final List<String> _symptoms = [];
  final TextEditingController _symptomController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _cycleLengthController = TextEditingController();
  int _cycleLength = 28; // Duração padrão do ciclo (28 dias)

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _cycleStartDate = DateTime.tryParse(prefs.getString('cycleStartDate') ?? '');
    _symptoms.addAll(prefs.getStringList('symptoms') ?? []);
    _cycleLength = prefs.getInt('cycleLength') ?? 28;
    _cycleLengthController.text = _cycleLength.toString();
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_cycleStartDate != null) {
      prefs.setString('cycleStartDate', _cycleStartDate!.toIso8601String());
    }
    prefs.setStringList('symptoms', _symptoms);
    prefs.setInt('cycleLength', _cycleLength);
  }

  void _updateCycleLength(String value) {
    final int? newLength = int.tryParse(value);
    if (newLength != null && newLength > 0) {
      setState(() {
        _cycleLength = newLength;
        _saveData();
      });
    }
  }

  bool _isValidCycleLength() => _cycleLength > 0;

  Widget _buildCycleLengthInput() {
    return TextField(
      controller: _cycleLengthController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Duração do ciclo (dias)',
        border: OutlineInputBorder(),
        errorText: _cycleLengthController.text.isNotEmpty && !_isValidCycleLength()
            ? 'Por favor, insira um número válido.'
            : null,
      ),
      onChanged: _updateCycleLength,
    );
  }

  Widget _buildCycleLengthFeedback() {
    return Text(
      'Duração atual do ciclo: $_cycleLength dias',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  DateTime get _nextPeriodDate =>
      (_cycleStartDate ?? DateTime.now()).add(Duration(days: _cycleLength));

  DateTime get _fertileStartDate =>
      (_cycleStartDate ?? DateTime.now()).add(Duration(days: _cycleLength - 14));

  DateTime get _fertileEndDate =>
      (_cycleStartDate ?? DateTime.now()).add(Duration(days: _cycleLength - 12));


  void _addSymptom() {
    if (_symptomController.text.isNotEmpty) {
      setState(() {
        _symptoms.add(_symptomController.text);
        _saveData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sintoma adicionado: ${_symptomController.text}')),
        );
        _symptomController.clear();
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _cycleStartDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.pink, // Cor principal do date picker
                onPrimary: Colors.white, // Texto dos botões
                onSurface: Colors.black, // Texto da data
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        _updateStartDate(pickedDate);
      }
    } catch (e) {
      _showErrorDialog(context, "Error picking date. Please try again.");
    }
  }


  void _updateStartDate(DateTime pickedDate) {
    if (pickedDate == null || pickedDate.isAfter(DateTime.now())) {
      // Validando a data, não permite datas futuras ou nulas.
      return;
    }

    setState(() {
      _cycleStartDate = pickedDate;
      _saveData();
    });
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  void _removeSymptom(int index) {
    setState(() {
      _symptoms.removeAt(index);
      _saveData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sintoma removido')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ciclo Menstrual',
          style: TextStyle(color: Colors.pinkAccent), // Título mais estilizado
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remover sombra para um visual mais limpo
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.pinkAccent), // Ícone de configuração
            onPressed: () {
              _showCycleLengthDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDateHeader(),
              const SizedBox(height: 10),
              _buildCycleStatus(),
              const SizedBox(height: 20),
              _buildContentSection(),
              const SizedBox(height: 20),
              _buildSymptomInput(),
              const SizedBox(height: 20),
              _buildSymptomList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showCycleLengthDialog(BuildContext context) {
    TextEditingController cycleLengthController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Duração do Ciclo Menstrual'),
          content: TextField(
            controller: cycleLengthController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Digite a duração do ciclo"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                // Aqui você pode salvar a duração do ciclo conforme necessário
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildDateHeader() {
    final DateTime today = DateTime.now();
    final String dayFormat = 'd';
    final List<String> weekDays = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final DateTime currentDay = today.subtract(Duration(days: today.weekday - 1 - index));
          final bool isToday = index == today.weekday - 1;

          return Container(
            decoration: BoxDecoration(
              color: isToday ? Colors.pinkAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  weekDays[index],
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                    color: isToday ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat(dayFormat).format(currentDay),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCycleStatus() {
    final daysUntilNextPeriod = _nextPeriodDate.difference(DateTime.now()).inDays;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _animation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildCycleProgress(),
              Positioned(
                child: _buildCycleStatusContainer(daysUntilNextPeriod),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCycleStatusContainer(int daysUntilNextPeriod) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade100, Colors.pinkAccent.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Menstruação em',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$daysUntilNextPeriod dias',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _selectStartDate(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.pink.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Definir data do ciclo',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleProgress() {
    final DateTime today = DateTime.now();
    final int daysSinceStart = _cycleStartDate != null
        ? today.difference(_cycleStartDate!).inDays
        : 0;

    return SizedBox(
      width: 225,
      height: 225,
      child: CustomPaint(
        painter: CycleProgressPainter(
          daysSinceStart,
          _cycleLength,
          _fertileStartDate,
          _fertileEndDate,
        ),
      ),
    );
  }


  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conteúdo diário · Hoje',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContentCard('Dia do ciclo', '${_cycleStartDate != null ? DateTime.now().difference(_cycleStartDate!).inDays : 0}', Colors.pink),
              _buildContentCard('Fase fértil', '${_isInFertileWindow() ? 'Sim' : 'Não'}', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  bool _isInFertileWindow() {
    final today = DateTime.now();
    return today.isAfter(_fertileStartDate) && today.isBefore(_fertileEndDate);
  }

  Widget _buildContentCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      child: SizedBox(
        width: 150,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _symptomController,
            decoration: const InputDecoration(
              labelText: 'Adicione um sintoma',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          onPressed: _addSymptom,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildSymptomList() {
    return Expanded(
      child: _symptoms.isEmpty
          ? const Center(
        child: Text(
          'Nenhum sintoma registrado.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _symptoms.length,
        itemBuilder: (context, index) {
          final symptom = _symptoms[index];
          final timestamp = DateTime.now().toIso8601String(); // Exemplo de timestamp, pode ajustar.

          return Dismissible(
            key: Key(symptom),
            onDismissed: (direction) {
              setState(() {
                _removeSymptom(index);
              });
              Fluttertoast.showToast(
                msg: "Sintoma removido",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  symptom,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(timestamp)),
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showSymptomDetails(symptom, timestamp);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSymptomDetails(String symptom, String timestamp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detalhes do Sintoma"),
          content: Text(
            'Sintoma: $symptom\nRegistrado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(timestamp))}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }


}

class CycleProgressPainter extends CustomPainter {
  final int daysSinceStart;
  final int cycleLength;
  final DateTime fertileStartDate;
  final DateTime fertileEndDate;

  CycleProgressPainter(this.daysSinceStart, this.cycleLength, this.fertileStartDate, this.fertileEndDate);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBackground = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final Paint paintProgress = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.fill;

    final Paint paintFertile = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paintBackground);

    final double progressAngle = (2 * 3.14159265359 * (daysSinceStart % cycleLength) / cycleLength);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.14159265359 / 2,
      progressAngle,
      true,
      paintProgress,
    );

    final double fertileStartAngle = (2 * 3.14159265359 * (cycleLength - (fertileEndDate.difference(fertileStartDate).inDays + 12)) / cycleLength);
    final double fertileEndAngle = (2 * 3.14159265359 * (cycleLength - (fertileStartDate.difference(fertileEndDate).inDays)) / cycleLength);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.14159265359 / 2 + fertileStartAngle,
      fertileEndAngle - fertileStartAngle,
      true,
      paintFertile,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

