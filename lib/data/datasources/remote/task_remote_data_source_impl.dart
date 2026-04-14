import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../models/task_model.dart';
import '../task_remote_data_source.dart';

@Injectable(as: TaskRemoteDataSource)
class FirestoreTaskDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .set(task.toJson())
        .timeout(const Duration(seconds: 15));
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update(task.toJson())
        .timeout(const Duration(seconds: 15));
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .delete()
        .timeout(const Duration(seconds: 15));
  }

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList());
  }
}
