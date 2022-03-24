class FullUser {
  final User user;
  final String token;

  const FullUser({required this.user, required this.token});

  factory FullUser.fromJson(Map<String, dynamic> parsedJson) {
    return FullUser(
        user: User.fromJson(parsedJson['user']), token: parsedJson['token']);
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String? groupId;
  final String? imageUrl;
  final String? jobTitle;
  final String? phoneNumber;
  final String? address;
  final String registeredDate;
  final String? status;
  final int isAdmin;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? background;

  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.emailVerifiedAt,
      required this.createdAt,
      required this.updatedAt,
      this.groupId,
      this.imageUrl,
      this.jobTitle,
      this.phoneNumber,
      this.address,
      required this.registeredDate,
      this.status,
      required this.isAdmin,
      this.emergencyName,
      this.emergencyPhone,
      this.background});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        groupId: json['group_id'],
        imageUrl: json['image_url'],
        jobTitle: json['job_title'],
        phoneNumber: json['phone_number'],
        address: json['address'],
        registeredDate: json['registered_date'],
        status: json['status'],
        isAdmin: json['is_admin'],
        emergencyName: json['emergency_name'],
        emergencyPhone: json['emergency_phone'],
        background: json['background']);
  }
}
