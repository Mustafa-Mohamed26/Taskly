import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  static Future<void> execute(String email) async {
    return await getIt<AuthRepository>().forgotPassword(email);
  }
}
