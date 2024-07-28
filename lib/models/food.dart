import 'package:macro_tracker/models/macro.dart';

class Food {
  final String name;
  final Macro macro;

  Food({required this.name, required this.macro});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'carb': macro.carb,
      'fat': macro.fat,
      'protein': macro.protein,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'],
      macro: Macro(
        carb: map['carb'],
        fat: map['fat'],
        protein: map['protein'],
      ),
    );
  }
}
