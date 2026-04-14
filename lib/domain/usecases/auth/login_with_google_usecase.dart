import 'package:get_it/get_it.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  static Future<UserEntity> execute() async {
    final repository = GetIt.I<AuthRepository>();
    return await repository.loginWithGoogle();
  }
}
