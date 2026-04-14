import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/entities/task_entity.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  StreamSubscription? _tasksSubscription;

  HomeCubit() : super(HomeState.initial());

  void init(String userId) {
    _tasksSubscription?.cancel();
    emit(state.copyWith(isLoading: true));
    
    _tasksSubscription = WatchTasksUseCase.execute(userId).listen((allTasks) {
      final now = DateTime.now();
      
      final todayTasks = allTasks.where((task) {
        return task.dateTime.year == now.year &&
               task.dateTime.month == now.month &&
               task.dateTime.day == now.day;
      }).toList();

      final completedToday = todayTasks.where((t) => t.isCompleted).length;
      final totalToday = todayTasks.length;
      final progress = totalToday > 0 ? completedToday / totalToday : 0.0;

      emit(state.copyWith(
        allTasks: allTasks,
        todayTasks: todayTasks,
        completedToday: completedToday,
        totalToday: totalToday,
        progress: progress,
        isLoading: false,
      ));
    });
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
