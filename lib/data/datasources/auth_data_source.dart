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
  Future<UserModel?> getUserProfile(String uid);
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  });

  Future<UserModel> loginWithGoogle();

  Stream<UserModel?> get authStateChanges;

  Future<UserModel?> get currentAuthenticatedUser;

  Future<void> deleteAccount(String uid);
}
