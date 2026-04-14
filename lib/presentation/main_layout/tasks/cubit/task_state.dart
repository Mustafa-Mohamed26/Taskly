part of 'task_cubit.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {
  final List<TaskEntity> previousData;
  TaskLoading([this.previousData = const []]);
}

class TaskSuccess<T> extends TaskState {
  final T data;
  TaskSuccess(this.data);
}

class TaskActionSuccess extends TaskState {
  final String message;
  final List<TaskEntity> tasks;
  TaskActionSuccess(this.message, [this.tasks = const []]);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
