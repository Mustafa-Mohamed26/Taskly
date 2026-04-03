import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../entities/task_entity.dart';
import '../../repositories/task_repository.dart';

@injectable
class WatchTasksUseCase {
  static Stream<List<TaskEntity>> execute(String userId) {
    return getIt<TaskRepository>().watchTasks(userId);
  }
}
