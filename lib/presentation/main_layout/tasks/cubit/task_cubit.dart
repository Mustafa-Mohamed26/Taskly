import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/entities/task_entity.dart';
import '../../../../../domain/usecases/tasks/add_task_usecase.dart';
import '../../../../../domain/usecases/tasks/delete_task_usecase.dart';
import '../../../../../domain/usecases/tasks/update_task_usecase.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  StreamSubscription? _tasksSubscription;
  List<TaskEntity> _currentTasks = [];

  void watchTasks(String userId) {
    _tasksSubscription?.cancel();
    _tasksSubscription = WatchTasksUseCase.execute(userId).listen(
      (tasks) {
        _currentTasks = tasks;
        emit(TaskSuccess<List<TaskEntity>>(tasks));
      },
      onError: (e) {
        emit(TaskError(e.toString()));
      },
    );
  }

  Future<void> addTask(TaskEntity task) async {
    emit(TaskLoading(_currentTasks));
    try {
      await AddTaskUseCase.execute(task);
      emit(TaskActionSuccess('Task created successfully', _currentTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    emit(TaskLoading(_currentTasks));
    try {
      await UpdateTaskUseCase.execute(task);
      emit(TaskActionSuccess('Task updated successfully', _currentTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(TaskEntity task) async {
    emit(TaskLoading(_currentTasks));
    try {
      await DeleteTaskUseCase.execute(task.id);
      emit(TaskActionSuccess('Task deleted successfully', _currentTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
