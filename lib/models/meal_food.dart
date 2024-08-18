import 'package:macro_tracker/models/food.dart';

class MealFood {
  final Food food;
  final int amount;

  MealFood({
    required this.food,
    this.amount = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(),
      'amount': amount,
    };
  }

  factory MealFood.fromMap(Map<String, dynamic> map) {
    return MealFood(
      food: Food.fromMap(map['food']),
      amount: map['amount'] ?? 1,
    );
  }
}
