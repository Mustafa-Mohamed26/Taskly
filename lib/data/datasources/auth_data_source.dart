import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> forgotPassword(String email);

  Future<void> saveUserProfile(UserModel user);

  Stream<UserModel?> get authStateChanges;

  Future<UserModel?> get currentAuthenticatedUser;
}
