import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../../domain/usecases/auth/get_authenticated_user_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/update_user_profile_usecase.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void checkAuth() {
    GetAuthenticatedUserUseCase.execute().listen((user) {
      if (user != null) {
        if (state is! Authenticated &&
            state is! LoginSuccess &&
            state is! RegisterSuccess) {
          emit(Authenticated(user));
        }
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await LoginUseCase.execute(email: email, password: password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await RegisterUseCase.execute(
        name: name,
        email: email,
        password: password,
      );
      emit(RegisterSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await LogoutUseCase.execute();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await ForgotPasswordUseCase.execute(email);
      emit(ForgotPasswordSuccess('Reset link sent to your email'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  }) async {
    UserEntity? currentUser;
    if (state is Authenticated) {
      currentUser = (state as Authenticated).user;
    } else if (state is LoginSuccess) {
      currentUser = (state as LoginSuccess).user;
    } else if (state is RegisterSuccess) {
      currentUser = (state as RegisterSuccess).user;
    }

    emit(AuthLoading());
    try {
      await UpdateUserProfileUseCase.execute(
        uid: uid,
        name: name,
        phone: phone,
        bio: bio,
      );
      
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: name ?? currentUser.name,
          phone: phone ?? currentUser.phone,
          bio: bio ?? currentUser.bio,
        );
        emit(ProfileUpdateSuccess(updatedUser));
        emit(Authenticated(updatedUser));
      } else {
        // Fallback in case state wasn't captured gracefully
        emit(ProfileUpdateSuccess(
          UserEntity(id: uid, email: '', name: name, phone: phone, bio: bio)
        ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
