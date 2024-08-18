import 'dart:io';
import 'dart:convert';
import 'package:macro_tracker/models/meal_entry.dart';
import 'package:macro_tracker/models/meal_food.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:macro_tracker/models/food.dart';
import 'package:macro_tracker/models/macro.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('macros.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const foodTable = '''
    CREATE TABLE foods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      carb REAL NOT NULL,
      fat REAL NOT NULL,
      protein REAL NOT NULL,
      serving TEXT NOT NULL
    );
    ''';

    const macroTable = '''
    CREATE TABLE daily_macros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      carb REAL NOT NULL,
      fat REAL NOT NULL,
      protein REAL NOT NULL
    );
    ''';

    const mealEntryTable = '''
    CREATE TABLE meal_entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      mealFoods TEXT NOT NULL,
      carb REAL NOT NULL,
      fat REAL NOT NULL,
      protein REAL NOT NULL
    );
    ''';

    await db.execute(foodTable);
    await db.execute(macroTable);
    await db.execute(mealEntryTable);
  }

  Future<int> insertFood(Food food) async {
    final db = await instance.database;
    return await db.insert('foods', food.toMap());
  }

  Future<void> updateFood(Food food) async {
    final db = await instance.database;
    await db
        .update('foods', food.toMap(), where: 'id = ?', whereArgs: [food.id]);
  }

  Future<void> deleteFood(int id) async {
    final db = await instance.database;
    await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertMacro(Macro macro) async {
    final db = await instance.database;
    await db.insert('daily_macros', macro.toMap());
  }

  Future<List<Food>> fetchFoods() async {
    final db = await instance.database;
    final maps = await db.query('foods');

    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<Macro> fetchDailyMacros() async {
    final db = await instance.database;
    final maps = await db.query('daily_macros', orderBy: 'id DESC', limit: 1);

    if (maps.isNotEmpty) {
      return Macro.fromMap(maps.first);
    } else {
      return Macro(carb: 0, fat: 0, protein: 0);
    }
  }

  Future<void> clearDailyMacros() async {
    final db = await instance.database;
    await db.delete('daily_macros');
  }

  Future<void> insertMealEntry(MealEntry mealEntry) async {
    final db = await instance.database;
    await db.insert('meal_entries', {
      'name': mealEntry.name,
      'mealFoods': jsonEncode(
          mealEntry.mealFoods.map((mealFood) => mealFood.toMap()).toList()),
      'carb': mealEntry.customMacro.carb,
      'fat': mealEntry.customMacro.fat,
      'protein': mealEntry.customMacro.protein,
    });
  }

  Future<List<MealEntry>> fetchMealEntries() async {
    final db = await instance.database;
    final maps = await db.query('meal_entries');

    return List.generate(maps.length, (i) {
      return MealEntry(
        id: maps[i]['id'] as int?,
        name: maps[i]['name'] as String,
        mealFoods: (jsonDecode(maps[i]['mealFoods'] as String) as List<dynamic>)
            .map((mealFoodMap) =>
                MealFood.fromMap(mealFoodMap as Map<String, dynamic>))
            .toList(),
        customMacro: Macro(
          carb: maps[i]['carb'] as double? ?? 0.0,
          fat: maps[i]['fat'] as double? ?? 0.0,
          protein: maps[i]['protein'] as double? ?? 0.0,
        ),
      );
    });
  }

  Future<void> updateMealEntry(MealEntry mealEntry) async {
    final db = await instance.database;
    await db.update(
        'meal_entries',
        {
          'name': mealEntry.name,
          'mealFoods': jsonEncode(
              mealEntry.mealFoods.map((mealFood) => mealFood.toMap()).toList()),
          'carb': mealEntry.customMacro.carb,
          'fat': mealEntry.customMacro.fat,
          'protein': mealEntry.customMacro.protein,
        },
        where: 'id = ?',
        whereArgs: [mealEntry.id]);
  }

  Future<void> deleteMealEntry(int id) async {
    final db = await instance.database;
    await db.delete('meal_entries', where: 'id = ?', whereArgs: [id]);
  }
}
