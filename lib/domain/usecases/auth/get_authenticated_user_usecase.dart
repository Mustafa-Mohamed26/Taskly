import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/user_entity.dart';

@injectable
class GetAuthenticatedUserUseCase {
  static Stream<UserEntity?> execute() {
    return getIt<AuthRepository>().authStateChanges;
  }
}
