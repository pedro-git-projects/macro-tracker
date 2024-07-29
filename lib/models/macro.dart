class Macro {
  final double carb;
  final double fat;
  final double protein;

  Macro({required this.carb, required this.fat, required this.protein})
      : assert(carb.isFinite, 'carb value should be finite'),
        assert(fat.isFinite, 'fat value should be finite'),
        assert(protein.isFinite, 'protein value should be finite');

  double get calories => (carb * 4) + (fat * 9) + (protein * 4);

  @override
  String toString() {
    return 'Macro(carb: $carb, fat: $fat, protein: $protein, calories: $calories)';
  }

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
