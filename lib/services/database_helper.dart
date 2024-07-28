import 'dart:io';
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
      protein REAL NOT NULL
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

    await db.execute(foodTable);
    await db.execute(macroTable);
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
}
