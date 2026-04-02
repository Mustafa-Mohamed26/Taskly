part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess<T> extends AuthState {
  final T data;
  AuthSuccess(this.data);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
