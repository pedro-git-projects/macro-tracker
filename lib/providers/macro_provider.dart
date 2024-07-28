import 'package:flutter/material.dart';
import 'package:macro_tracker/models/food.dart';
import 'package:macro_tracker/models/macro.dart';
import 'package:macro_tracker/services/database_helper.dart';

class MacroProvider with ChangeNotifier {
  Macro _dailyMacros = Macro(carb: 0, fat: 0, protein: 0);
  List<Food> _foods = [];

  Macro get dailyMacros => _dailyMacros;
  List<Food> get foods => _foods;

  MacroProvider() {
    _loadData();
  }

  void _loadData() async {
    _dailyMacros = await DatabaseHelper.instance.fetchDailyMacros();
    _foods = await DatabaseHelper.instance.fetchFoods();
    notifyListeners();
  }

  void addFood(Food food) async {
    await DatabaseHelper.instance.insertFood(food);
    _foods = await DatabaseHelper.instance.fetchFoods();
    notifyListeners();
  }

  void addMacros(Macro macro) async {
    _dailyMacros = Macro(
      carb: _dailyMacros.carb + macro.carb,
      fat: _dailyMacros.fat + macro.fat,
      protein: _dailyMacros.protein + macro.protein,
    );
    await DatabaseHelper.instance.insertMacro(_dailyMacros);
    notifyListeners();
  }

  void clearDailyMacros() async {
    await DatabaseHelper.instance.clearDailyMacros();
    _dailyMacros = Macro(carb: 0, fat: 0, protein: 0);
    notifyListeners();
  }
}
