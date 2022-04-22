class FullGroup {
  final List<Group> groups;

  const FullGroup({required this.groups});

  factory FullGroup.fromJson(List<dynamic> parsedJson) {
    List<Group> groups = [];
    groups = parsedJson.map((i) => Group.fromJson(i)).toList();

    return FullGroup(groups: groups);
  }
}

class Group {
  final int id;
  final String name;
  final String? admin;
  final String createdAt;
  final String updatadAt;

  const Group(
      {required this.id,
      required this.name,
      this.admin,
      required this.createdAt,
      required this.updatadAt});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      admin: json['admin'],
      createdAt: json['created_at'],
      updatadAt: json['updated_at'],
    );
  }
}
