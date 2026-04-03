import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> forgotPassword(String email);

  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> get currentAuthenticatedUser;
}
