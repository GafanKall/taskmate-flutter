class WeeklySchedule {
  final int id;
  final int userId;
  final String title;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WeeklySchedule({
    required this.id,
    required this.userId,
    required this.title,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
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
      'user_id': userId,
      'title': title,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
