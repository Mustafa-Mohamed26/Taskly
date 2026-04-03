part of 'task_cubit.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess<T> extends TaskState {
  final T data;
  TaskSuccess(this.data);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
