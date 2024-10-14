import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  _StatCardState createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  double elevation = 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        elevation = 2;
      }),
      onTapUp: (_) => setState(() {
        elevation = 4;
      }),
      onTapCancel: () => setState(() {
        elevation = 4;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: elevation * 3,
              offset: Offset(0, elevation),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [widget.color.withOpacity(0.6), widget.color],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                  ),
                  child: Icon(widget.icon, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.value, // Exibe o valor com a unidade de medida diretamente
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      barGroups: _getBarData(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarData() {
    // Dados de exemplo, substitua pelos seus dados
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: widget.color)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: widget.color)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: widget.color)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 10, color: widget.color)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 5, color: widget.color)]),
      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 4, color: widget.color)]),
      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 9, color: widget.color)]),
    ];
  }
}
