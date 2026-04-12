// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/service/audio_service.dart' as _i306;
import '../../core/service/database_helper.dart' as _i512;
import '../../data/datasources/auth_data_source.dart' as _i305;
import '../../data/datasources/local/task_local_data_source_impl.dart' as _i180;
import '../../data/datasources/remote/auth_remote_data_source_impl.dart'
    as _i743;
import '../../data/datasources/remote/task_remote_data_source_impl.dart'
    as _i832;
import '../../data/datasources/task_local_data_source.dart' as _i272;
import '../../data/datasources/task_remote_data_source.dart' as _i807;
import '../../data/repositories/remote/auth_repository_impl.dart' as _i381;
import '../../data/repositories/remote/task_repository_impl.dart' as _i538;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/task_repository.dart' as _i250;
import '../../domain/usecases/auth/forgot_password_usecase.dart' as _i674;
import '../../domain/usecases/auth/get_authenticated_user_usecase.dart' as _i65;
import '../../domain/usecases/auth/login_usecase.dart' as _i461;
import '../../domain/usecases/auth/logout_usecase.dart' as _i320;
import '../../domain/usecases/auth/register_usecase.dart' as _i659;
import '../../domain/usecases/tasks/add_task_usecase.dart' as _i797;
import '../../domain/usecases/tasks/delete_task_usecase.dart' as _i363;
import '../../domain/usecases/tasks/get_tasks_usecase.dart' as _i577;
import '../../domain/usecases/tasks/update_task_usecase.dart' as _i715;
import '../../domain/usecases/tasks/watch_tasks_usecase.dart' as _i938;
import '../../presentation/auth/cubit/auth_cubit.dart' as _i1063;
import '../../presentation/main_layout/focus/cubit/focus_cubit.dart' as _i107;
import '../../presentation/main_layout/tasks/cubit/sync_cubit.dart' as _i571;
import '../../presentation/main_layout/tasks/cubit/task_cubit.dart' as _i20;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i674.ForgotPasswordUseCase>(
      () => _i674.ForgotPasswordUseCase(),
    );
    gh.factory<_i65.GetAuthenticatedUserUseCase>(
      () => _i65.GetAuthenticatedUserUseCase(),
    );
    gh.factory<_i461.LoginUseCase>(() => _i461.LoginUseCase());
    gh.factory<_i320.LogoutUseCase>(() => _i320.LogoutUseCase());
    gh.factory<_i659.RegisterUseCase>(() => _i659.RegisterUseCase());
    gh.factory<_i797.AddTaskUseCase>(() => _i797.AddTaskUseCase());
    gh.factory<_i363.DeleteTaskUseCase>(() => _i363.DeleteTaskUseCase());
    gh.factory<_i577.GetTasksUseCase>(() => _i577.GetTasksUseCase());
    gh.factory<_i715.UpdateTaskUseCase>(() => _i715.UpdateTaskUseCase());
    gh.factory<_i938.WatchTasksUseCase>(() => _i938.WatchTasksUseCase());
    gh.factory<_i1063.AuthCubit>(() => _i1063.AuthCubit());
    gh.factory<_i107.FocusCubit>(() => _i107.FocusCubit());
    gh.factory<_i20.TaskCubit>(() => _i20.TaskCubit());
    gh.singleton<_i512.DatabaseHelper>(() => _i512.DatabaseHelper());
    gh.lazySingleton<_i306.AudioService>(() => _i306.AudioService());
    gh.factory<_i305.AuthDataSource>(() => _i743.FirebaseAuthDataSourceImpl());
    gh.factory<_i807.TaskRemoteDataSource>(
      () => _i832.FirestoreTaskDataSourceImpl(),
    );
    gh.factory<_i1073.AuthRepository>(
      () => _i381.AuthRepositoryImpl(gh<_i305.AuthDataSource>()),
    );
    gh.factory<_i272.TaskLocalDataSource>(
      () => _i180.SqfliteTaskDataSourceImpl(gh<_i512.DatabaseHelper>()),
    );
    gh.factory<_i250.TaskRepository>(
      () => _i538.TaskRepositoryImpl(
        gh<_i807.TaskRemoteDataSource>(),
        gh<_i272.TaskLocalDataSource>(),
      ),
    );
    gh.factory<_i571.SyncCubit>(
      () => _i571.SyncCubit(gh<_i250.TaskRepository>(), gh<_i1063.AuthCubit>()),
    );
    return this;
  }
}
