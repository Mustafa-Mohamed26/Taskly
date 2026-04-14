import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../datasources/task_data_source.dart';
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
    
    await _localDataSource.addTask(taskModel.copyWith(isSynced: false, updatedAt: DateTime.now().millisecondsSinceEpoch));
    _refreshLocalTasks(taskModel.userId);
    
    try {
      await _remoteDataSource.addTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
    } catch (e) {
      // Stay unsynced, background sync will try later
    }
  }

  Future<void> _refreshLocalTasks(String userId) async {
    final tasks = await _localDataSource.getTasks(userId);
    _tasksSubject.add(tasks);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    
    await _localDataSource.updateTask(taskModel.copyWith(isSynced: false, updatedAt: DateTime.now().millisecondsSinceEpoch));
    _refreshLocalTasks(taskModel.userId);
    
    try {
      await _remoteDataSource.updateTask(taskModel);
      await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
    } catch (e) {
      // Stay unsynced, background sync will try later
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
      // If remote delete succeeds, we can hard-delete locally to save space
      await _localDataSource.hardDeleteTask(taskId);
    } catch (e) {
      // Stay soft-deleted and unsynced
    }
  }

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    _remoteSubscription?.cancel();
    
    // 1. Return Zero-Latency Local Stream
    _refreshLocalTasks(userId);

    // 2. Start Background Sync (Remote -> Local)
    _remoteSubscription = _remoteDataSource.watchTasks(userId).listen((remoteModels) async {
      final localTasks = await _localDataSource.getTasks(userId);
      
      for (var remoteTask in remoteModels) {
        final localTask = localTasks.where((t) => t.id == remoteTask.id).firstOrNull;
        
        if (localTask == null) {
          // New task from remote
          await _localDataSource.addTask(remoteTask.copyWith(isSynced: true));
        } else {
          // Conflict Resolution: Only update if remote is newer AND local is synced
          // If local is NOT synced, we prefer local changes (priority to local)
          if (localTask.isSynced && remoteTask.updatedAt > localTask.updatedAt) {
            await _localDataSource.updateTask(remoteTask.copyWith(isSynced: true));
          }
        }
      }
      
      // Update the UI from the now-merged local database
      _refreshLocalTasks(userId);
    });

    return _tasksSubject.stream;
  }

  @override
  Future<void> syncTasks(String userId) async {
    // 1. Sync additions and updates
    final List<TaskModel> unsyncedTasks = await _localDataSource.getUnsyncedTasks();
    for (var taskModel in unsyncedTasks) {
      try {
        await _remoteDataSource.addTask(taskModel);
        await _localDataSource.updateTask(taskModel.copyWith(isSynced: true));
      } catch (e) {
        // Continue to next task
      }
    }

    // 2. Sync deletions
    final List<TaskModel> deletedTasks = await _localDataSource.getDeletedUnsyncedTasks();
    for (var taskModel in deletedTasks) {
      if (taskModel.userId != userId) continue; // Isolation safety
      try {
        await _remoteDataSource.deleteTask(taskModel.id);
        await _localDataSource.hardDeleteTask(taskModel.id);
      } catch (e) {
        // Continue
      }
    }
  }
}
