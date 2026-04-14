import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import '../../../../../domain/repositories/task_repository.dart';
import 'sync_state.dart';

@injectable
class SyncCubit extends Cubit<SyncState> {
  final TaskRepository _repository;
  final AuthCubit _authCubit;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  SyncCubit(this._repository, this._authCubit) : super(const SyncState()) {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        _triggerSync();
      }
    });

    // Also trigger on startup if online
    _triggerSync();
  }

  Future<void> _triggerSync() async {
    final authState = _authCubit.state;
    String? userId;
    if (authState is Authenticated) userId = authState.user.id;
    if (authState is LoginSuccess) userId = authState.user.id;
    if (authState is RegisterSuccess) userId = authState.user.id;

    if (userId != null && state.status != SyncStatus.syncing) {
      emit(state.copyWith(status: SyncStatus.syncing));
      try {
        await _repository.syncTasks(userId);
        emit(state.copyWith(
          status: SyncStatus.success,
          lastSyncedAt: DateTime.now().toIso8601String(),
        ));
      } catch (e) {
        emit(state.copyWith(status: SyncStatus.error, errorMessage: e.toString()));
      }
    }
  }

  void forceSync() => _triggerSync();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
