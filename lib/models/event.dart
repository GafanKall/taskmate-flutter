class Event {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final String? color;
  final bool allDay;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Event({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    this.color,
    this.allDay = false,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      color: json['color'],
      allDay: json['all_day'] ?? false,
      category: json['category'],
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
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'color': color,
      'all_day': allDay,
      'category': category,
    };
  }
}
