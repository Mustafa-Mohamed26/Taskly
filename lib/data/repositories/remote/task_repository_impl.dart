import 'package:injectable/injectable.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../datasources/task_local_data_source.dart';
import '../../datasources/task_remote_data_source.dart';
import '../../models/task_model.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<TaskEntity>> getTasks(String userId) async {
    final List<TaskModel> localTasks = await _localDataSource.getTasks(userId);
    
    try {
      final List<TaskModel> remoteTasks = await _remoteDataSource.getTasks(userId);
      await _localDataSource.cacheTasks(remoteTasks);
      return remoteTasks;
    } catch (e) {
      return localTasks;
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    
    await _localDataSource.addTask(taskModel.copyWith(isSynced: false) as TaskModel);
    
    try {
      await _remoteDataSource.addTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true) as TaskModel);
    } catch (e) {
      // Stay unsynced
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    
    await _localDataSource.updateTask(taskModel.copyWith(isSynced: false) as TaskModel);
    
    try {
      await _remoteDataSource.updateTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true) as TaskModel);
    } catch (e) {
      // Stay unsynced
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _localDataSource.deleteTask(taskId);
    
    try {
      await _remoteDataSource.deleteTask(taskId);
    } catch (e) {
      // Handle remote delete failure
    }
  }

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    return _remoteDataSource.watchTasks(userId).map((models) {
      _localDataSource.cacheTasks(models);
      return models;
    });
  }

  @override
  Future<void> syncTasks(String userId) async {
    final List<TaskModel> unsyncedTasks = await _localDataSource.getUnsyncedTasks();
    for (var taskModel in unsyncedTasks) {
      try {
        await _remoteDataSource.addTask(taskModel);
        await _localDataSource.updateTask(taskModel.copyWith(isSynced: true) as TaskModel);
      } catch (e) {
        // Skip
      }
    }
  }
}
