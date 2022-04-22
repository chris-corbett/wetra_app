class FullSchedule {
  final List<Schedule> schedules;

  const FullSchedule({required this.schedules});

  factory FullSchedule.fromJson(List<dynamic> parsedJson) {
    List<Schedule> schedules = [];
    schedules = parsedJson.map((i) => Schedule.fromJson(i)).toList();

    return FullSchedule(schedules: schedules);
  }
}

class Schedule {
  final int id;
  final String? scheduleType;
  final String title;
  final String start;
  final String end;
  final String color;
  final String textColor;
  final String? description;
  final int assignedTo;
  final int assignedBy;
  final int? isCompleted;
  final int? requestTimeOffId;
  final int? confirmTimeOffId;
  final String createdAt;
  final String updatedAt;
  final int? allDay;
  final int? isGroup;

  const Schedule(
      {required this.id,
      this.scheduleType,
      required this.title,
      required this.start,
      required this.end,
      required this.color,
      required this.textColor,
      this.description,
      required this.assignedTo,
      required this.assignedBy,
      this.isCompleted,
      this.requestTimeOffId,
      this.confirmTimeOffId,
      required this.createdAt,
      required this.updatedAt,
      this.allDay,
      this.isGroup});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        scheduleType: json['scheduleType'],
        title: json['title'],
        start: json['start'],
        end: json['end'],
        color: json['color'],
        textColor: json['textColor'],
        description: json['description'],
        assignedTo: json['assigned_to'],
        assignedBy: json['assigned_by'],
        isCompleted: json['is_completed'],
        requestTimeOffId: json['request_time_off_id'],
        confirmTimeOffId: json['confirm_time_off_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        allDay: json['allDay'],
        isGroup: json['is_group']);
  }
}
