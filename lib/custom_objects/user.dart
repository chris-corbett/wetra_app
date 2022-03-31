import 'package:wetra_app/custom_objects/login_user.dart';

// Class used to store the users information after they have logged in
class User {
  static late LoginFullUser user;

  static void setUser(LoginFullUser newUser) {
    user = newUser;
  }

  static LoginFullUser getUser() {
    return user;
  }
}
