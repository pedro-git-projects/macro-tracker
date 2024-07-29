import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:macro_tracker/models/macro.dart';

class MacroBarChart extends StatelessWidget {
  final Macro goalMacros;
  final Macro consumedMacros;

  const MacroBarChart({
    super.key,
    required this.goalMacros,
    required this.consumedMacros,
  });

  @override
  Widget build(BuildContext context) {
    if (_hasNaN(goalMacros) ||
        _hasNaN(consumedMacros) ||
        _isZero(goalMacros) ||
        _isZero(consumedMacros)) {
      return const Center(child: CircularProgressIndicator());
    }

    // Additional debug prints
    print('Building chart with goal macros: $goalMacros');
    print('Building chart with consumed macros: $consumedMacros');

    return Column(
      children: [
        Text('Macros: Goal vs Consumed',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        _buildStackedBarChart(),
        const SizedBox(height: 20),
        _buildLegend(),
      ],
    );
  }

  bool _hasNaN(Macro macros) {
    return macros.carb.isNaN || macros.fat.isNaN || macros.protein.isNaN;
  }

  bool _isZero(Macro macros) {
    return macros.carb == 0.0 && macros.fat == 0.0 && macros.protein == 0;
  }

  Widget _buildStackedBarChart() {
    final chartData = _getChartData();

    // Print the chart data for debugging
    for (var data in chartData) {
      print(
          'Label: ${data.label}, Goal Value: ${data.goalValue}, Consumed Value: ${data.consumedValue}');
    }

    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          gridData: const FlGridData(show: false),
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: const Text('Carbs', style: style),
                      );
                    case 1:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: const Text('Fats', style: style),
                      );
                    case 2:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: const Text('Proteins', style: style),
                      );
                    default:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: const Text('', style: style),
                      );
                  }
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _getBarGroups(chartData),
        ),
      ),
    );
  }

  double _getMaxY() {
    List<double> values = [
      goalMacros.carb,
      goalMacros.fat,
      goalMacros.protein,
      consumedMacros.carb,
      consumedMacros.fat,
      consumedMacros.protein
    ];

    values = values.where((value) => value.isFinite && value > 0).toList();

    if (values.isEmpty) {
      return 1.0; // Ensure a default positive value for the y-axis maximum
    }

    double maxVal = values.reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2;
  }

  List<BarChartGroupData> _getBarGroups(List<_ChartData> chartData) {
    return chartData.asMap().entries.map((entry) {
      int index = entry.key;
      _ChartData data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.goalValue + data.consumedValue,
            rodStackItems: [
              BarChartRodStackItem(
                0,
                data.goalValue,
                Colors.blue,
              ),
              BarChartRodStackItem(
                data.goalValue,
                data.goalValue + data.consumedValue,
                Colors.red,
              ),
            ],
            borderRadius: BorderRadius.circular(6),
            width: 22,
          ),
        ],
      );
    }).toList();
  }

  List<_ChartData> _getChartData() {
    final data = [
      _ChartData('Carbs', goalMacros.carb.isFinite ? goalMacros.carb : 0.0,
          consumedMacros.carb.isFinite ? consumedMacros.carb : 0.0),
      _ChartData('Fats', goalMacros.fat.isFinite ? goalMacros.fat : 0.0,
          consumedMacros.fat.isFinite ? consumedMacros.fat : 0.0),
      _ChartData(
          'Proteins',
          goalMacros.protein.isFinite ? goalMacros.protein : 0.0,
          consumedMacros.protein.isFinite ? consumedMacros.protein : 0.0),
    ];

    // Print the data for debugging
    for (var data in data) {
      print(
          'Label: ${data.label}, Goal: ${data.goalValue}, Consumed: ${data.consumedValue}');
    }

    return data;
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Goal', Colors.blue),
        const SizedBox(width: 20),
        _buildLegendItem('Consumed', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _ChartData {
  final String label;
  final double goalValue;
  final double consumedValue;

  _ChartData(this.label, this.goalValue, this.consumedValue);
}
