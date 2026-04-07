class TaskEntity {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime dateTime;
  final List<String> categories;
  final String priority;
  final bool isCompleted;
  final bool isSynced;
  final int updatedAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dateTime,
    required this.categories,
    required this.priority,
    this.isCompleted = false,
    this.isSynced = true,
    required this.updatedAt,
  });

  TaskEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dateTime,
    List<String>? categories,
    String? priority,
    bool? isCompleted,
    bool? isSynced,
    int? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      categories: categories ?? this.categories,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
