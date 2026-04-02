import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/user_entity.dart';

@injectable
class RegisterUseCase {
  static Future<UserEntity> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    return await getIt<AuthRepository>().register(name: name, email: email, password: password);
  }
}
