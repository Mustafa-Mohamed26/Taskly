part of 'focus_cubit.dart';

abstract class FocusState {
  final int duration;
  FocusState(this.duration);
}

class FocusInitial extends FocusState {
  FocusInitial(super.duration);
}

class FocusRunning extends FocusState {
  FocusRunning(super.duration);
}

class FocusPaused extends FocusState {
  FocusPaused(super.duration);
}

class FocusCompleted extends FocusState {
  FocusCompleted() : super(0);
}
