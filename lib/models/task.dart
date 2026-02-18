class Task {
  final int id;
  final int boardId;
  final int userId;
  final String title;
  final String? priority;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool completed;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.boardId,
    required this.userId,
    required this.title,
    this.priority,
    this.status,
    this.startDate,
    this.endDate,
    this.completed = false,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      boardId: json['board_id'],
      userId: json['user_id'],
      title: json['title'],
      priority: json['priority'],
      status: json['status'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      completed: json['completed'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'board_id': boardId,
      'user_id': userId,
      'title': title,
      'priority': priority,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'completed': completed,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
