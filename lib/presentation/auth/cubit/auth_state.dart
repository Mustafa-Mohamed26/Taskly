part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// For background auth check (e.g., Splash Screen)
class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

// For manual Login action
class LoginSuccess extends AuthState {
  final UserEntity user;
  LoginSuccess(this.user);
}

// For manual Register action
class RegisterSuccess extends AuthState {
  final UserEntity user;
  RegisterSuccess(this.user);
}

// For manual Forgot Password action
class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
