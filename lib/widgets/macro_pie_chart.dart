import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:macro_tracker/models/macro.dart';

class MacroPieChart extends StatelessWidget {
  final Macro goalMacros;
  final Macro consumedMacros;

  const MacroPieChart({
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

    return Column(
      children: [
        Text('Macros: Goal vs Consumed',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        _buildPieChart('Carbs', goalMacros.carb, consumedMacros.carb),
        const SizedBox(height: 20),
        _buildPieChart('Fats', goalMacros.fat, consumedMacros.fat),
        const SizedBox(height: 20),
        _buildPieChart('Proteins', goalMacros.protein, consumedMacros.protein),
      ],
    );
  }

  bool _hasNaN(Macro macros) {
    return macros.carb.isNaN || macros.fat.isNaN || macros.protein.isNaN;
  }

  bool _isZero(Macro macros) {
    return macros.carb == 0.0 && macros.fat == 0.0 && macros.protein == 0;
  }

  Widget _buildPieChart(String title, double goal, double consumed) {
    return Column(
      children: [
        Text(title),
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    return;
                  }
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: _showingSections(goal, consumed),
            ),
          ),
        ),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _showingSections(double goal, double consumed) {
    final total = goal + consumed;
    final goalPercentage = (goal / total) * 100;
    final consumedPercentage = (consumed / total) * 100;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: goalPercentage,
        title: '${goalPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: consumedPercentage,
        title: '${consumedPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
