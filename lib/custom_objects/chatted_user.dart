class ChattedUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  //final String background;

  ChattedUser.fromJson(Map json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        email = json['email'];
  //background: json['image_url'],

  Map toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email
    };
  }
}
