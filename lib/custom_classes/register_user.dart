class RegisterFullError {
  final String message;
  final RegisterError errors;

  const RegisterFullError({required this.message, required this.errors});

  factory RegisterFullError.fromJson(Map<String, dynamic> parsedJson) {
    return RegisterFullError(
        message: parsedJson['message'],
        errors: RegisterError.fromJson(parsedJson['errors']));
  }
}

class RegisterError {
  final List<dynamic>? email;
  final List<dynamic>? password;

  const RegisterError({this.email, this.password});

  factory RegisterError.fromJson(Map<String, dynamic> json) {
    return RegisterError(email: json['email'], password: json['password']);
  }
}
