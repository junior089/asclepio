import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenstrualCyclePage extends StatefulWidget {
  const MenstrualCyclePage({Key? key}) : super(key: key);

  @override
  _MenstrualCyclePageState createState() => _MenstrualCyclePageState();
}

class _MenstrualCyclePageState extends State<MenstrualCyclePage> {
  DateTime? _cycleStartDate;
  final int _cycleLength = 28;
  final List<String> _symptoms = [];
  final TextEditingController _symptomController = TextEditingController();

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sintoma adicionado: ${_symptomController.text}')),
        );
        _symptomController.clear();
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _cycleStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _cycleStartDate = picked;
      });
    }
  }

  void _removeSymptom(int index) {
    setState(() {
      _symptoms.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sintoma removido')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Ciclo Menstrual'),
        backgroundColor: Colors.white10,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildDateHeader(),
            const SizedBox(height: 20),
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
    );
  }

  Widget _buildDateHeader() {
    final DateTime today = DateTime.now();
    final String dayFormat = 'd';
    final List<String> weekDays = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final DateTime currentDay = today.subtract(Duration(days: today.weekday - 1 - index));
          return Column(
            children: [
              Text(
                weekDays[index],
                style: TextStyle(
                  fontWeight: index == 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat(dayFormat).format(currentDay),
                style: TextStyle(
                  color: index == 3 ? Colors.pink : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCycleStatus() {
    final daysUntilNextPeriod = _nextPeriodDate.difference(DateTime.now()).inDays;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 225,
          height: 225,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Menstruação em',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
                '$daysUntilNextPeriod dias',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _selectStartDate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Definir data do ciclo'),
              ),
            ],
          ),
        ),
        _buildCycleProgress(),
      ],
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
        painter: CycleProgressPainter(daysSinceStart, _cycleLength, _fertileStartDate, _fertileEndDate),
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
              _buildContentCard('Dia do ciclo', '${_cycleStartDate != null ? DateTime.now().difference(_cycleStartDate!).inDays : 0}', Colors.purple[100]!),
              _buildContentCard('Sintomas', '${_symptoms.length}', Colors.blue[100]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String subtitle, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                labelText: 'Adicionar sintoma',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSymptom,
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: _symptoms.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2,
              child: ListTile(
                title: Text(_symptoms[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeSymptom(index),
                ),
              ),
            );
          },
        ),
      ),
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
    final double radius = size.width / 2;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Define colors for each phase
    Color menstruationColor = Colors.red;
    Color fertileColor = Colors.green;
    Color otherColor = Colors.blue;

    // Draw the circle for menstruation
    if (daysSinceStart < 5) {
      paint.color = menstruationColor;
      canvas.drawArc(Offset.zero & size, -90 * (3.14 / 180), (daysSinceStart / 5) * (3.14 * 2), false, paint);
    }

    // Draw the circle for fertile phase
    if (daysSinceStart >= 5 && daysSinceStart < cycleLength) {
      paint.color = fertileColor;
      canvas.drawArc(Offset.zero & size, -90 * (3.14 / 180), (daysSinceStart - 5) / 12 * (3.14 * 2), false, paint);
    }

    // Draw the remaining cycle
    if (daysSinceStart >= cycleLength) {
      paint.color = otherColor;
      canvas.drawArc(Offset.zero & size, -90 * (3.14 / 180), (cycleLength) * (3.14 * 2), false, paint);
    }

    // Draw outer progress bar
    Paint outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Colors.grey[300]!;

    canvas.drawCircle(Offset(radius, radius), radius - 4, outerPaint);

    // Draw segments for each phase
    drawSegment(canvas, size, -90, 5, menstruationColor);
    drawSegment(canvas, size, 5, 12, fertileColor);
    drawSegment(canvas, size, 17, cycleLength - 17, otherColor);
  }

  void drawSegment(Canvas canvas, Size size, double startDegree, double extent, Color color) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawArc(
      Offset.zero & size,
      startDegree * (3.14 / 180),
      extent * (3.14 / 180),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
