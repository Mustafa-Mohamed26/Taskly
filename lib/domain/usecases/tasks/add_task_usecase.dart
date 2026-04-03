import 'package:injectable/injectable.dart';
import '../../../config/di/di.dart';
import '../../entities/task_entity.dart';
import '../../repositories/task_repository.dart';

@injectable
class AddTaskUseCase {
  static Future<void> execute(TaskEntity task) async {
    return await getIt<TaskRepository>().addTask(task);
  }
}
