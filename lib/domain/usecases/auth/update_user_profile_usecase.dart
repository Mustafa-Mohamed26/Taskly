import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/auth_repository.dart';

@injectable
class UpdateUserProfileUseCase {
  static Future<void> execute({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  }) async {
    return await getIt<AuthRepository>().updateUserProfile(
      uid: uid,
      name: name,
      phone: phone,
      bio: bio,
    );
  }
}
