import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/entities/task_entity.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'schedule_state.dart';

@injectable
class ScheduleCubit extends Cubit<ScheduleState> {
  StreamSubscription? _tasksSubscription;

  ScheduleCubit() : super(ScheduleState.initial());

  void init(String userId) {
    _tasksSubscription?.cancel();
    emit(state.copyWith(isLoading: true));

    _tasksSubscription = WatchTasksUseCase.execute(userId).listen((allTasks) {
      _allTasksUpdated(allTasks);
    });
  }

  void _allTasksUpdated(List<TaskEntity> allTasks) {
    final filtered = allTasks
        .where((t) => _isSameDay(t.dateTime, state.selectedDate))
        .toList();
    emit(state.copyWith(
      allTasks: allTasks,
      filteredTasks: filtered,
      isLoading: false,
    ));
  }

  void selectDate(DateTime date) {
    final filtered = state.allTasks
        .where((t) => _isSameDay(t.dateTime, date))
        .toList();
    emit(state.copyWith(selectedDate: date, filteredTasks: filtered));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
