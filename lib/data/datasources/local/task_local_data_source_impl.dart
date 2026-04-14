import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/service/database_helper.dart';
import '../../models/task_model.dart';
import '../task_data_source.dart';

@Injectable(as: TaskLocalDataSource)
class SqfliteTaskDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _databaseHelper;

  SqfliteTaskDataSourceImpl(this._databaseHelper);

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => TaskModel.fromSql(map)).toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'tasks',
      task.toSql(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await _databaseHelper.database;
    await db.update(
      'tasks',
      task.toSql(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final db = await _databaseHelper.database;
    await db.update(
      'tasks',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();
    for (var task in tasks) {
      batch.insert(
        'tasks',
        task.toSql(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'is_synced = ? AND is_deleted = 0',
      whereArgs: [0],
    );
    return maps.map((map) => TaskModel.fromSql(map)).toList();
  }

  @override
  Future<List<TaskModel>> getDeletedUnsyncedTasks() async {
    final db = await _databaseHelper.database;
    // We want tasks that are marked as deleted but NOT synced (meaning the remote doesn't know they are deleted yet)
    final maps = await db.query(
      'tasks',
      where: 'is_synced = ? AND is_deleted = 1',
      whereArgs: [0],
    );
    return maps.map((map) => TaskModel.fromSql(map)).toList();
  }

  @override
  Future<void> hardDeleteTask(String taskId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
