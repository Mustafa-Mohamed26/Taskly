import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'focus_state.dart';

@injectable
class FocusCubit extends Cubit<FocusState> {
  Timer? _timer;
  int _initialDuration = 25 * 60; // Default 25 minutes
  int _remainingSeconds = 25 * 60;

  FocusCubit() : super(FocusInitial(25 * 60));

  void startTimer() {
    if (_timer != null) return;
    
    emit(FocusRunning(_remainingSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        emit(FocusRunning(_remainingSeconds));
      } else {
        stopTimer();
        emit(FocusCompleted());
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    emit(FocusPaused(_remainingSeconds));
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = _initialDuration;
    emit(FocusInitial(_initialDuration));
  }

  void setDuration(int minutes) {
    _initialDuration = minutes * 60;
    _remainingSeconds = _initialDuration;
    emit(FocusInitial(_initialDuration));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
