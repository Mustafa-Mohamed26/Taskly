part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<TaskEntity> todayTasks;
  final List<TaskEntity> allTasks;
  final double progress;
  final int completedToday;
  final int totalToday;
  final bool isLoading;

  const HomeState({
    this.todayTasks = const [],
    this.allTasks = const [],
    this.progress = 0.0,
    this.completedToday = 0,
    this.totalToday = 0,
    this.isLoading = false,
  });

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({
    List<TaskEntity>? todayTasks,
    List<TaskEntity>? allTasks,
    double? progress,
    int? completedToday,
    int? totalToday,
    bool? isLoading,
  }) {
    return HomeState(
      todayTasks: todayTasks ?? this.todayTasks,
      allTasks: allTasks ?? this.allTasks,
      progress: progress ?? this.progress,
      completedToday: completedToday ?? this.completedToday,
      totalToday: totalToday ?? this.totalToday,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        todayTasks,
        allTasks,
        progress,
        completedToday,
        totalToday,
        isLoading,
      ];
}
