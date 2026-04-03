import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  static Future<void> execute() async {
    return await getIt<AuthRepository>().logout();
  }
}
