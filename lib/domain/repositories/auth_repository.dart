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

  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  });

  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> get currentAuthenticatedUser;
}
