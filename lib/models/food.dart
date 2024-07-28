import 'package:macro_tracker/models/macro.dart';

class Food {
  final int? id;
  final String name;
  final Macro macro;
  final String amount;

  Food(
      {this.id, required this.name, required this.macro, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'carb': macro.carb,
      'fat': macro.fat,
      'protein': macro.protein,
      'amount': amount,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      macro: Macro(
        carb: map['carb'],
        fat: map['fat'],
        protein: map['protein'],
      ),
      amount: map['amount'],
    );
  }
}
