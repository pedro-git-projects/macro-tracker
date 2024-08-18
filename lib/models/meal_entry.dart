import 'macro.dart';
import 'food.dart';

class MealEntry {
  final int? id;
  final String name;
  final List<Food> foods;
  final Macro customMacro;

  static int _mealCounter = 1;

  MealEntry({
    this.id,
    String? name,
    required this.foods,
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
      'foods': foods.map((food) => food.toMap()).toList(),
      'carb': customMacro.carb,
      'fat': customMacro.fat,
      'protein': customMacro.protein,
    };
  }

  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      id: map['id'],
      name: map['name'],
      foods: (map['foods'] as List)
          .map((foodMap) => Food.fromMap(foodMap))
          .toList(),
      customMacro: Macro(
        carb: map['carb'],
        fat: map['fat'],
        protein: map['protein'],
      ),
    );
  }
}
