class ChatUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  //final String background;

  const ChatUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.background,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      //background: json['image_url'],
    );
  }
}
