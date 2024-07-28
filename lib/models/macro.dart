class Macro {
  final double carb;
  final double fat;
  final double protein;

  Macro({required this.carb, required this.fat, required this.protein});

  double get calories => (carb * 4) + (fat * 9) + (protein * 4);

  Map<String, dynamic> toMap() {
    return {
      'carb': carb,
      'fat': fat,
      'protein': protein,
    };
  }

  factory Macro.fromMap(Map<String, dynamic> map) {
    return Macro(
      carb: map['carb'],
      fat: map['fat'],
      protein: map['protein'],
    );
  }
}
