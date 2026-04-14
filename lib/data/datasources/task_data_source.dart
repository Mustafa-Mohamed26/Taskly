import '../models/task_model.dart';

abstract class TaskDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

abstract class TaskLocalDataSource extends TaskDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getUnsyncedTasks();
  Future<List<TaskModel>> getDeletedUnsyncedTasks();
  Future<void> hardDeleteTask(String taskId);
}

abstract class TaskRemoteDataSource extends TaskDataSource {
  Stream<List<TaskModel>> watchTasks(String userId);
}
