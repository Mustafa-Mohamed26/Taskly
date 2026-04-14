import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    required super.dateTime,
    required super.categories,
    required super.priority,
    super.isCompleted,
    super.isSynced,
    super.isDeleted,
    required super.updatedAt,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      dateTime: entity.dateTime,
      categories: entity.categories,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      isSynced: entity.isSynced,
      isDeleted: entity.isDeleted,
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
      categories: List<String>.from(json['categories'] ?? (json['category'] != null ? [json['category']] : [])),
      priority: json['priority'],
      isCompleted: json['isCompleted'] ?? json['is_completed'] ?? false,
      isSynced: json['isSynced'] ?? json['is_synced'] ?? true,
      isDeleted: json['isDeleted'] ?? json['is_deleted'] ?? false,
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
      'categories': categories,
      'priority': priority,
      'isCompleted': isCompleted,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
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
      categories: (map['category'] as String).split(',').where((s) => s.isNotEmpty).toList(),
      priority: map['priority'],
      isCompleted: map['is_completed'] == 1,
      isSynced: map['is_synced'] == 1,
      isDeleted: map['is_deleted'] == 1,
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
      'category': categories.join(','),
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'updated_at': updatedAt,
    };
  }

  @override
  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dateTime,
    List<String>? categories,
    String? priority,
    bool? isCompleted,
    bool? isSynced,
    bool? isDeleted,
    int? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      categories: categories ?? this.categories,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
