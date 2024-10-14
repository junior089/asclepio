import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightChart extends StatelessWidget {
  final List<double> weightData; // Lista de pesos

  const WeightChart({Key? key, required this.weightData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent, width: 1.5),
            ),
            child: const Text(
              "Gráfico de Peso",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 350,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  verticalInterval: 1,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.withOpacity(0.5), strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: Colors.grey.withOpacity(0.5), strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 14, color: Colors.black)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: Text(value.toString(), style: const TextStyle(fontSize: 14, color: Colors.black)),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.7), width: 1)),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(weightData.length, (index) => FlSpot(index.toDouble(), weightData[index])),
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 5,
                    belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.3)),
                    showingIndicators: const [], // Tooltips (se necessário)
                  ),
                ],
                maxY: weightData.reduce((a, b) => a > b ? a : b) + 5, // Margem superior
                minY: weightData.reduce((a, b) => a < b ? a : b) - 5, // Margem inferior
                backgroundColor: Colors.white, // Fundo do gráfico
              ),
            ),
          ),
        ],
      ),
    );
  }
}
