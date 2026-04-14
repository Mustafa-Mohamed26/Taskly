import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../domain/entities/task_entity.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'calendar_view_state.dart';

@injectable
class CalendarViewCubit extends Cubit<CalendarViewState> {
  StreamSubscription? _tasksSubscription;

  CalendarViewCubit() : super(CalendarViewState.initial());

  void init(String userId) {
    _tasksSubscription?.cancel();
    emit(state.copyWith(isLoading: true));

    _tasksSubscription = WatchTasksUseCase.execute(userId).listen((allTasks) {
      _allTasksUpdated(allTasks);
    });
  }

  void _allTasksUpdated(List<TaskEntity> allTasks) {
    final filtered = allTasks
        .where((t) => _isSameDay(t.dateTime, state.selectedDay))
        .toList();
    emit(state.copyWith(
      allTasks: allTasks,
      selectedDayTasks: filtered,
      isLoading: false,
    ));
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final filtered = state.allTasks
        .where((t) => _isSameDay(t.dateTime, selectedDay))
        .toList();
    emit(state.copyWith(
      selectedDay: selectedDay,
      focusedDay: focusedDay,
      selectedDayTasks: filtered,
    ));
  }

  void onFormatChanged(CalendarFormat format) {
    emit(state.copyWith(calendarFormat: format));
  }

  void changeFocusedDay(DateTime focusedDay) {
    emit(state.copyWith(focusedDay: focusedDay));
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
