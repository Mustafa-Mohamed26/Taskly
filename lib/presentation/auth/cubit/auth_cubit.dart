import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../../domain/usecases/auth/get_authenticated_user_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void checkAuth() {
    GetAuthenticatedUserUseCase.execute().listen((user) {
      if (user != null) {
        emit(AuthSuccess<UserEntity>(user));
      } else {
        emit(AuthInitial());
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await LoginUseCase.execute(email: email, password: password);
      emit(AuthSuccess<UserEntity>(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await RegisterUseCase.execute(name: name, email: email, password: password);
      emit(AuthSuccess<UserEntity>(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await LogoutUseCase.execute();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await ForgotPasswordUseCase.execute(email);
      emit(AuthSuccess<String>('Reset link sent to your email'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
