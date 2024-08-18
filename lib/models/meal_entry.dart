import 'package:macro_tracker/models/meal_food.dart';

import 'macro.dart';

class MealEntry {
  final int? id;
  final String name;
  final List<MealFood> mealFoods;
  final Macro customMacro;

  static int _mealCounter = 1;

  MealEntry({
    this.id,
    String? name,
    required this.mealFoods,
    required this.customMacro,
  }) : name = (name == null || name.isEmpty) ? 'Meal $_mealCounter' : name {
    if (name == null || name.isEmpty) {
      _mealCounter++;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'foods': mealFoods.map((food) => food.toMap()).toList(),
      'carb': customMacro.carb,
      'fat': customMacro.fat,
      'protein': customMacro.protein,
    };
  }

  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      id: map['id'],
      name: map['name'],
      mealFoods: (map['mealFoods'] as List)
          .map((foodMap) => MealFood.fromMap(foodMap))
          .toList(),
      customMacro: Macro(
        carb: map['carb'],
        fat: map['fat'],
        protein: map['protein'],
      ),
    );
  }
}
