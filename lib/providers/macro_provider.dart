import 'package:flutter/material.dart';
import 'package:macro_tracker/models/food.dart';
import 'package:macro_tracker/models/macro.dart';
import 'package:macro_tracker/models/meal_entry.dart';
import 'package:macro_tracker/services/database_helper.dart';

class MacroProvider with ChangeNotifier {
  Macro _dailyMacros = Macro(carb: 0, fat: 0, protein: 0);
  List<Food> _foods = [];
  List<MealEntry> _mealEntries = [];

  Macro get dailyMacros => _dailyMacros;
  List<Food> get foods => _foods;
  List<MealEntry> get mealEntries => _mealEntries;

  MacroProvider() {
    _loadData();
  }

  void _loadData() async {
    _dailyMacros = await DatabaseHelper.instance.fetchDailyMacros();
    _foods = await DatabaseHelper.instance.fetchFoods();
    _mealEntries = await DatabaseHelper.instance.fetchMealEntries();

    assert(
        _dailyMacros.carb.isFinite, '_dailyMacros carb value should be finite');
    assert(
        _dailyMacros.fat.isFinite, '_dailyMacros fat value should be finite');
    assert(_dailyMacros.protein.isFinite,
        '_dailyMacros protein value should be finite');

    for (var food in _foods) {
      assert(
          food.macro.carb.isFinite, 'food macro carb value should be finite');
      assert(food.macro.fat.isFinite, 'food macro fat value should be finite');
      assert(food.macro.protein.isFinite,
          'food macro protein value should be finite');
    }

    for (var meal in _mealEntries) {
      for (var mealFood in meal.mealFoods) {
        final food = mealFood.food;
        assert(food.macro.carb.isFinite,
            'meal food macro carb value should be finite');
        assert(food.macro.fat.isFinite,
            'meal food macro fat value should be finite');
        assert(food.macro.protein.isFinite,
            'meal food macro protein value should be finite');
      }
      assert(meal.customMacro.carb.isFinite,
          'meal customMacro carb value should be finite');
      assert(meal.customMacro.fat.isFinite,
          'meal customMacro fat value should be finite');
      assert(meal.customMacro.protein.isFinite,
          'meal customMacro protein value should be finite');
    }

    notifyListeners();
  }

  void addFood(Food food) async {
    int id = await DatabaseHelper.instance.insertFood(food);
    food =
        Food(id: id, name: food.name, macro: food.macro, serving: food.serving);
    _foods.add(food);
    notifyListeners();
  }

  void updateFood(int index, Food newFood) async {
    await DatabaseHelper.instance.updateFood(newFood);
    _foods[index] = newFood;
    notifyListeners();
  }

  void deleteFood(int index) async {
    await DatabaseHelper.instance.deleteFood(_foods[index].id!);
    _foods.removeAt(index);
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

  void addMealEntry(MealEntry mealEntry) async {
    await DatabaseHelper.instance.insertMealEntry(mealEntry);
    _mealEntries = await DatabaseHelper.instance.fetchMealEntries();
    notifyListeners();
  }

  void updateMealEntry(MealEntry mealEntry) async {
    await DatabaseHelper.instance.updateMealEntry(mealEntry);
    _mealEntries = await DatabaseHelper.instance.fetchMealEntries();
    notifyListeners();
  }

  void deleteMealEntry(int id) async {
    await DatabaseHelper.instance.deleteMealEntry(id);
    _mealEntries = await DatabaseHelper.instance.fetchMealEntries();
    notifyListeners();
  }

  Macro get totalIntake {
    double totalCarbs = 0;
    double totalFats = 0;
    double totalProteins = 0;

    for (var meal in _mealEntries) {
      for (var mealFood in meal.mealFoods) {
        totalCarbs += mealFood.food.macro.carb * mealFood.amount;
        totalFats += mealFood.food.macro.fat * mealFood.amount;
        totalProteins += mealFood.food.macro.protein * mealFood.amount;
      }

      totalCarbs += meal.customMacro.carb;
      totalFats += meal.customMacro.fat;
      totalProteins += meal.customMacro.protein;
    }

    return Macro(carb: totalCarbs, fat: totalFats, protein: totalProteins);
  }
}
