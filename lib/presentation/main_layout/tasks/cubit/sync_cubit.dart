import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/presentation/auth/cubit/auth_cubit.dart';
import '../../../../../domain/repositories/task_repository.dart';

@injectable
class SyncCubit extends Cubit<void> {
  final TaskRepository _repository;
  final AuthCubit _authCubit;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  SyncCubit(this._repository, this._authCubit) : super(null) {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        _triggerSync();
      }
    });
  }

  void _triggerSync() {
    final state = _authCubit.state;
    String? userId;
    if (state is Authenticated) userId = state.user.id;
    if (state is LoginSuccess) userId = state.user.id;
    if (state is RegisterSuccess) userId = state.user.id;

    if (userId != null) {
      _repository.syncTasks(userId);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
