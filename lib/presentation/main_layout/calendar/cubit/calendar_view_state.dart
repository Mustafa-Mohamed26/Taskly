part of 'calendar_view_cubit.dart';

class CalendarViewState extends Equatable {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final List<TaskEntity> allTasks;
  final List<TaskEntity> selectedDayTasks;
  final bool isLoading;

  const CalendarViewState({
    required this.focusedDay,
    required this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
    this.allTasks = const [],
    this.selectedDayTasks = const [],
    this.isLoading = false,
  });

  factory CalendarViewState.initial() {
    final now = DateTime.now();
    return CalendarViewState(
      focusedDay: now,
      selectedDay: now,
    );
  }

  CalendarViewState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
    List<TaskEntity>? allTasks,
    List<TaskEntity>? selectedDayTasks,
    bool? isLoading,
  }) {
    return CalendarViewState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      allTasks: allTasks ?? this.allTasks,
      selectedDayTasks: selectedDayTasks ?? this.selectedDayTasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        focusedDay,
        selectedDay,
        calendarFormat,
        allTasks,
        selectedDayTasks,
        isLoading,
      ];
}
