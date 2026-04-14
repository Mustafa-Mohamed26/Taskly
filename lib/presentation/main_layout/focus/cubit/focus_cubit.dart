import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/domain/entities/task_entity.dart';

part 'focus_state.dart';

@injectable
class FocusCubit extends Cubit<FocusState> {
  Timer? _timer;

  FocusCubit() : super(FocusState.initial());

  void startTimer() {
    if (_timer != null) return;

    emit(state.copyWith(status: FocusStatus.running));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      } else {
        stopTimer();
        emit(state.copyWith(status: FocusStatus.completed, remainingSeconds: 0));
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(status: FocusStatus.paused));
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(
      status: FocusStatus.initial,
      remainingSeconds: state.duration,
    ));
  }

  void setDuration(int minutes) {
    emit(state.copyWith(
      duration: minutes * 60,
      remainingSeconds: minutes * 60,
      status: FocusStatus.initial,
    ));
  }

  void selectTask(TaskEntity? task) {
    emit(state.copyWith(selectedTask: () => task));
  }

  void selectSound(String? sound) {
    emit(state.copyWith(selectedSound: () => sound));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
