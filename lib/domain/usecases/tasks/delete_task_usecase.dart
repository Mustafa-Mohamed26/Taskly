import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../repositories/task_repository.dart';

@injectable
class DeleteTaskUseCase {
  static Future<void> execute(String taskId) async {
    return await getIt<TaskRepository>().deleteTask(taskId);
  }
}
