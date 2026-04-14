part of 'focus_cubit.dart';

enum FocusStatus { initial, running, paused, completed }

class FocusState extends Equatable {
  final int duration;
  final int remainingSeconds;
  final FocusStatus status;
  final TaskEntity? selectedTask;
  final String? selectedSound;

  const FocusState({
    required this.duration,
    required this.remainingSeconds,
    required this.status,
    this.selectedTask,
    this.selectedSound,
  });

  factory FocusState.initial() => const FocusState(
        duration: 25 * 60,
        remainingSeconds: 25 * 60,
        status: FocusStatus.initial,
      );

  FocusState copyWith({
    int? duration,
    int? remainingSeconds,
    FocusStatus? status,
    TaskEntity? Function()? selectedTask,
    String? Function()? selectedSound,
  }) {
    return FocusState(
      duration: duration ?? this.duration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
      selectedSound: selectedSound != null ? selectedSound() : this.selectedSound,
    );
  }

  @override
  List<Object?> get props => [duration, remainingSeconds, status, selectedTask, selectedSound];
}
