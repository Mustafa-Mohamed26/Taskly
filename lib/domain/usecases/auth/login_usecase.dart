import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/user_entity.dart';

@injectable
class LoginUseCase {
  static Future<UserEntity> execute({
    required String email,
    required String password,
  }) async {
    return await getIt<AuthRepository>().login(email: email, password: password);
  }
}
