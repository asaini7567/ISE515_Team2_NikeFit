import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('local_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT,
        shoe_size REAL,
        foot_length REAL,
        arch_length REAL,
        foot_width_heel REAL,
        heel_to_toe_diagonal REAL,
        toe_box_width REAL,
        foot_width_forefoot REAL
      )
    ''');

    // Insert hard-coded data with category
    await db.insert('measurements', {
      'name': 'Nike Dunk Low Retro',
      'category': 'Casual',
      'shoe_size': 8.5,
      'foot_length': 28.0,
      'arch_length': 18.0,
      'foot_width_heel': 7.0,
      'heel_to_toe_diagonal': 27.5,
      'toe_box_width': 10.0,
      'foot_width_forefoot': 9.0
    });

    await db.insert('measurements', {
      'name': 'Nike Air Force 1',
      'category': 'Casual',
      'shoe_size': 8.5,
      'foot_length': 28.2,
      'arch_length': 20.3,
      'foot_width_heel': 7.7,
      'heel_to_toe_diagonal': 28.6,
      'toe_box_width': 10.1,
      'foot_width_forefoot': 8.9
    });

    await db.insert('measurements', {
      'name': 'Nike Air Jordan 1',
      'category': 'Sports',
      'shoe_size': 8.5,
      'foot_length': 27.0,
      'arch_length': 15.5,
      'foot_width_heel': 6.4,
      'heel_to_toe_diagonal': 26.7,
      'toe_box_width': 9.5,
      'foot_width_forefoot': 8.5
    });

    await db.insert('measurements', {
      'name': 'Nike Flyknit Air Max Multi-Color',
      'category': 'Running',
      'shoe_size': 8.5,
      'foot_length': 26.7,
      'arch_length': 17.8,
      'foot_width_heel': 8.9,
      'heel_to_toe_diagonal': 25.4,
      'toe_box_width': 7.6,
      'foot_width_forefoot': 8.6
    });

    await db.insert('measurements', {
      'name': 'Nike React Infinity Run Flyknit',
      'category': 'Running',
      'shoe_size': 9.0,
      'foot_length': 27.9,
      'arch_length': 19.1,
      'foot_width_heel': 5.7,
      'heel_to_toe_diagonal': 28.7,
      'toe_box_width': 8.9,
      'foot_width_forefoot': 8.3
    });
  }

  Future<int> insertMeasurement(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('measurements', row);
  }

  Future<List<Map<String, dynamic>>> fetchAllMeasurements() async {
    final db = await instance.database;
    return await db.query('measurements');
  }

  Future<int> updateMeasurement(Map<String, dynamic> row) async {
    final db = await instance.database;
    final id = row['id'] as int;
    return await db.update(
      'measurements',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMeasurement(int id) async {
    final db = await instance.database;
    return await db.delete(
      'measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
