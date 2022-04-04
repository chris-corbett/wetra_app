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
  final String title;
  final String start;
  final String end;
  final String color;
  final String textColor;
  final String description;
  final int assignedTo;
  final int assignedBy;
  final String createdAt;
  final String updatedAt;
  final String? allDay;

  const Schedule(
      {required this.id,
      required this.title,
      required this.start,
      required this.end,
      required this.color,
      required this.textColor,
      required this.description,
      required this.assignedTo,
      required this.assignedBy,
      required this.createdAt,
      required this.updatedAt,
      this.allDay});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        title: json['title'],
        start: json['start'],
        end: json['end'],
        color: json['color'],
        textColor: json['textColor'],
        description: json['description'],
        assignedTo: json['assigned_to'],
        assignedBy: json['assigned_by'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        allDay: json['allDay']);
  }
}
