import 'package:flutter/material.dart';
import 'package:macro_tracker/models/food.dart';

class FoodListItem extends StatelessWidget {
  final Food food;

  const FoodListItem({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(food.name),
      subtitle: Text(
          'Carbs: ${food.macro.carb}g, Fats: ${food.macro.fat}g, Proteins: ${food.macro.protein}g'),
      trailing: Text('${food.macro.calories.toStringAsFixed(2)} kcal'),
    );
  }
}
