import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    required super.dateTime,
    required super.category,
    required super.priority,
    super.isCompleted,
    super.isSynced,
    required super.updatedAt,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      dateTime: entity.dateTime,
      category: entity.category,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      isSynced: entity.isSynced,
      updatedAt: entity.updatedAt,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      userId: json['userId'] ?? json['user_id'] ?? '',
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime'] ?? json['date_time']),
      category: json['category'],
      priority: json['priority'],
      isCompleted: json['isCompleted'] ?? json['is_completed'] ?? false,
      isSynced: json['isSynced'] ?? json['is_synced'] ?? true,
      updatedAt: json['updatedAt'] ?? json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
      'isSynced': isSynced,
      'updatedAt': updatedAt,
    };
  }

  // Helper for Sqflite
  factory TaskModel.fromSql(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['user_id'] ?? '',
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['date_time']),
      category: map['category'],
      priority: map['priority'],
      isCompleted: map['is_completed'] == 1,
      isSynced: map['is_synced'] == 1,
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toSql() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'category': category,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
      'updated_at': updatedAt,
    };
  }
}
