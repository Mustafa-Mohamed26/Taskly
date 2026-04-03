import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/entities/task_entity.dart';
import '../../../../../domain/usecases/tasks/add_task_usecase.dart';
import '../../../../../domain/usecases/tasks/delete_task_usecase.dart';
import '../../../../../domain/usecases/tasks/get_tasks_usecase.dart';
import '../../../../../domain/usecases/tasks/update_task_usecase.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'task_state.dart';

@injectable
class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  void getTasks(String userId) async {
    emit(TaskLoading());
    try {
      final tasks = await GetTasksUseCase.execute(userId);
      emit(TaskSuccess<List<TaskEntity>>(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void watchTasks(String userId) {
    WatchTasksUseCase.execute(userId).listen(
      (tasks) {
        emit(TaskSuccess<List<TaskEntity>>(tasks));
      },
      onError: (e) {
        emit(TaskError(e.toString()));
      },
    );
  }

  Future<void> addTask(TaskEntity task) async {
    emit(TaskLoading());
    try {
      await AddTaskUseCase.execute(task);
      // We don't need to emit success here if we are watching the stream,
      // but we emit a generic success for the UI to handle navigation.
      emit(TaskSuccess<void>(null));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      await UpdateTaskUseCase.execute(task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await DeleteTaskUseCase.execute(taskId);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
