import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductivityChart extends StatelessWidget {
  final Map<String, double> data;

  const ProductivityChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Sem dados suficientes para gerar o gráfico.'),
      );
    }

    final entries = data.entries.toList();
    // Encontrar o valor máximo para normalização (base 1.0 para o trilho)
    final maxVal = entries.fold<double>(
        0.001, (prev, element) => element.value > prev ? element.value : prev);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center, // Centraliza para ocupar o espaço de forma justa
        groupsSpace: 20, // Espaço entre grupos
        barTouchData: BarTouchData(enabled: false),
        maxY: 1.0,
        minY: 0,
        rotationQuarterTurns: 1,
        titlesData: FlTitlesData(
          show: true,
          // Physical Left (Logical Bottom)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 84,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < entries.length) {
                  String label = entries[index].key;
                  if (label.length > 10) label = '${label.substring(0, 8)}...';
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(
                      label,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC1C6D7),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Physical Right (Logical Top)
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < entries.length) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: Text(
                      '${(entries[index].value).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00EEFC),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: entries.asMap().entries.map((e) {
          final normalizedValue = e.value.value / maxVal;
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: normalizedValue.clamp(0.08, 1.0),
                width: 16, // Leve redução para equilíbrio
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B8EFF), Color(0xFF00EEFC)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1.0,
                  color: const Color(0xFF282A2E),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
