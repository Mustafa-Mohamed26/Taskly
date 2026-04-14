part of 'profile_stats_cubit.dart';

class ProfileStatsState extends Equatable {
  final int completedTasks;
  final int ongoingTasks;
  final int successRate;
  final bool isLoading;

  const ProfileStatsState({
    this.completedTasks = 0,
    this.ongoingTasks = 0,
    this.successRate = 0,
    this.isLoading = false,
  });

  factory ProfileStatsState.initial() => const ProfileStatsState();

  ProfileStatsState copyWith({
    int? completedTasks,
    int? ongoingTasks,
    int? successRate,
    bool? isLoading,
  }) {
    return ProfileStatsState(
      completedTasks: completedTasks ?? this.completedTasks,
      ongoingTasks: ongoingTasks ?? this.ongoingTasks,
      successRate: successRate ?? this.successRate,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [completedTasks, ongoingTasks, successRate, isLoading];
}
