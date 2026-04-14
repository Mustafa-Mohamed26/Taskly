import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../datasources/task_local_data_source.dart';
import '../../datasources/task_remote_data_source.dart';
import '../../models/task_model.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;

  final BehaviorSubject<List<TaskEntity>> _tasksSubject = BehaviorSubject<List<TaskEntity>>();
  StreamSubscription? _remoteSubscription;

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
    
    await _localDataSource.addTask(taskModel.copyWith(isSynced: false));
    _refreshLocalTasks(taskModel.userId);
    
    try {
      await _remoteDataSource.addTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
    } catch (e) {
      // Stay unsynced
    }
  }

  Future<void> _refreshLocalTasks(String userId) async {
    final tasks = await _localDataSource.getTasks(userId);
    _tasksSubject.add(tasks);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    
    await _localDataSource.updateTask(taskModel.copyWith(isSynced: false));
    _refreshLocalTasks(taskModel.userId);
    
    try {
      await _remoteDataSource.updateTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
    } catch (e) {
      // Stay unsynced
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    // We need userId to refresh local, but we don't have it here. 
    // Usually, we fetch the task first or pass userId.
    // For now, let's assume we can find the task in current subject to get userId.
    String? userId;
    if (_tasksSubject.hasValue) {
      final task = _tasksSubject.value.firstWhere((t) => t.id == taskId);
      userId = task.userId;
    }

    await _localDataSource.deleteTask(taskId);
    if (userId != null) _refreshLocalTasks(userId);
    
    try {
      await _remoteDataSource.deleteTask(taskId);
    } catch (e) {
      // Handle remote delete failure
    }
  }

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    _remoteSubscription?.cancel();
    
    // 1. Load from local first
    _refreshLocalTasks(userId);

    // 2. Watch remote and update local + subject
    _remoteSubscription = _remoteDataSource.watchTasks(userId).listen((models) {
      _localDataSource.cacheTasks(models);
      _tasksSubject.add(models);
    });

    return _tasksSubject.stream;
  }

  @override
  Future<void> syncTasks(String userId) async {
    final List<TaskModel> unsyncedTasks = await _localDataSource.getUnsyncedTasks();
    for (var taskModel in unsyncedTasks) {
      try {
        await _remoteDataSource.addTask(taskModel);
        await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
      } catch (e) {
        // Skip
      }
    }
  }
}
