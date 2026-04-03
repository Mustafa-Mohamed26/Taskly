import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../entities/task_entity.dart';
import '../../repositories/task_repository.dart';

@injectable
class GetTasksUseCase {
  static Future<List<TaskEntity>> execute(String userId) async {
    return await getIt<TaskRepository>().getTasks(userId);
  }
}
