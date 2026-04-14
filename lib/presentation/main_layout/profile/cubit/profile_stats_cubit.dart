import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../domain/usecases/tasks/watch_tasks_usecase.dart';

part 'profile_stats_state.dart';

@injectable
class ProfileStatsCubit extends Cubit<ProfileStatsState> {
  StreamSubscription? _tasksSubscription;

  ProfileStatsCubit() : super(ProfileStatsState.initial());

  void init(String userId) {
    _tasksSubscription?.cancel();
    emit(state.copyWith(isLoading: true));

    _tasksSubscription = WatchTasksUseCase.execute(userId).listen((allTasks) {
      final completed = allTasks.where((t) => t.isCompleted).length;
      final ongoing = allTasks.where((t) => !t.isCompleted).length;
      int successRate = 0;
      if (allTasks.isNotEmpty) {
        successRate = ((completed / allTasks.length) * 100).round();
      }

      emit(state.copyWith(
        completedTasks: completed,
        ongoingTasks: ongoing,
        successRate: successRate,
        isLoading: false,
      ));
    });
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
