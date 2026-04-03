// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/service/database_helper.dart' as _i512;
import '../../data/datasources/auth_data_source.dart' as _i305;
import '../../data/datasources/remote/auth_remote_data_source_impl.dart'
    as _i743;
import '../../data/repositories/remote/auth_repository_impl.dart' as _i381;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/usecases/auth/forgot_password_usecase.dart' as _i674;
import '../../domain/usecases/auth/get_authenticated_user_usecase.dart' as _i65;
import '../../domain/usecases/auth/login_usecase.dart' as _i461;
import '../../domain/usecases/auth/logout_usecase.dart' as _i320;
import '../../domain/usecases/auth/register_usecase.dart' as _i659;
import '../../presentation/auth/cubit/auth_cubit.dart' as _i1063;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i674.ForgotPasswordUseCase>(
        () => _i674.ForgotPasswordUseCase());
    gh.factory<_i65.GetAuthenticatedUserUseCase>(
        () => _i65.GetAuthenticatedUserUseCase());
    gh.factory<_i461.LoginUseCase>(() => _i461.LoginUseCase());
    gh.factory<_i320.LogoutUseCase>(() => _i320.LogoutUseCase());
    gh.factory<_i659.RegisterUseCase>(() => _i659.RegisterUseCase());
    gh.factory<_i1063.AuthCubit>(() => _i1063.AuthCubit());
    gh.singleton<_i512.DatabaseHelper>(() => _i512.DatabaseHelper());
    gh.factory<_i305.AuthDataSource>(() => _i743.FirebaseAuthDataSourceImpl());
    gh.factory<_i1073.AuthRepository>(
        () => _i381.AuthRepositoryImpl(gh<_i305.AuthDataSource>()));
    return this;
  }
}
