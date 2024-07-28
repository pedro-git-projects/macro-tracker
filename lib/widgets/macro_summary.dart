import 'package:flutter/material.dart';
import 'package:macro_tracker/models/macro.dart';

class MacroSummary extends StatelessWidget {
  final Macro macro;

  const MacroSummary({super.key, required this.macro});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Daily Macros:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Carbs: ${macro.carb.toStringAsFixed(2)}g'),
        Text('Fats: ${macro.fat.toStringAsFixed(2)}g'),
        Text('Proteins: ${macro.protein.toStringAsFixed(2)}g'),
        Text('Calories: ${macro.calories.toStringAsFixed(2)} kcal',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
