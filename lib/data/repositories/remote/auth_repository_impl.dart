import 'package:injectable/injectable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../datasources/auth_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    return await _remoteDataSource.logout();
  }

  @override
  Future<void> forgotPassword(String email) async {
    return await _remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  }) async {
    return await _remoteDataSource.updateUserProfile(
      uid: uid,
      name: name,
      phone: phone,
      bio: bio,
    );
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    return await _remoteDataSource.loginWithGoogle();
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> get currentAuthenticatedUser =>
      _remoteDataSource.currentAuthenticatedUser;
}
