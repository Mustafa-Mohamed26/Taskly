part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final DateTime selectedDate;
  final List<TaskEntity> filteredTasks;
  final List<TaskEntity> allTasks;
  final bool isLoading;

  const ScheduleState({
    required this.selectedDate,
    this.filteredTasks = const [],
    this.allTasks = const [],
    this.isLoading = false,
  });

  factory ScheduleState.initial() => ScheduleState(
        selectedDate: DateTime.now(),
      );

  ScheduleState copyWith({
    DateTime? selectedDate,
    List<TaskEntity>? filteredTasks,
    List<TaskEntity>? allTasks,
    bool? isLoading,
  }) {
    return ScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      allTasks: allTasks ?? this.allTasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedDate, filteredTasks, allTasks, isLoading];
}
