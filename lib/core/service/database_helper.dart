import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
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
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // 0 for false, 1 for true
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE tasks (
  id $idType,
  title $textType,
  description TEXT,
  date_time $textType,
  category $textType,
  priority $textType,
  is_completed $boolType,
  is_synced $boolType,
  updated_at $intType
)
''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
