import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wetra_app/Admin_side_pages/bottom_nav_bar.dart';
import 'package:wetra_app/Staff_side_pages/bottom_nav_bar.dart';
import 'package:wetra_app/custom_objects/login_user.dart';
import 'registration_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isChecked = false;
  late final int userID;
  late final String userName;

  // Checks the users login information when they press the login button.
  login() {
    userLogin(emailController.text, passwordController.text);
  }

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  // Sends http post request to the api to check if the user has entered
  // their correct login information and allows them to login if the information is correct.
  Future<LoginFullUser> userLogin(String email, String password) async {
    final response = await http.post(
      // API URL
      Uri.parse('https://wyibulayin.scweb.ca/wetra/api/login'),
      // Headers for the post request
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'XSRF-',
      },
      // Encoding for the body
      encoding: Encoding.getByName('utf-8'),
      // Body to send in the post request
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 201) {
      // If response gives status code 201 then the user exists and the login information is correct.
      // If that is the case navigate the user to the home screen and return the user object.
      //print(emailController.text);

      userID = LoginFullUser.fromJson(jsonDecode(response.body)).user.id;
      print("User ID is: $userID");
      userName =
          LoginFullUser.fromJson(jsonDecode(response.body)).user.firstName;
      print("User ID is: $userName");
      if (LoginFullUser.fromJson(jsonDecode(response.body)).user.isAdmin == 1) {
        print("Admin");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
      } else {
        print("Staff");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StaffHomeScreen()));
      }
      return LoginFullUser.fromJson(jsonDecode(response.body));
    } else {
      // If the response gives a status code other than 201 then some login information is incorrect
      // or an account does not exist for that user. If that is the case display the wrong information popup
      // and throw an exception so the user cannot login.
      incorrectInfo();
      throw Exception('Failed to login.');
    }
  }

  // Displays popup notification if the user enters incorrect login information.
  Future<String?> incorrectInfo() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Incorrect Email or Password'),
                content: const Text(
                    'The email or password you have entered is incorrect please try again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ]));
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromRGBO(203, 12, 66, 1),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: login,
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final rememberMe = Material(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
            child: Theme(
          data: ThemeData(
              unselectedWidgetColor:
                  const Color.fromRGBO(203, 12, 66, 1) // Your color
              ),
          child: Checkbox(
              activeColor: const Color.fromRGBO(203, 12, 66, 1),
              value: isChecked,
              onChanged: _handleRemeberme),
        )),
        const SizedBox(width: 20.0),
        const Text("Remember Me",
            style: TextStyle(
                color: Color.fromRGBO(203, 12, 66, 1),
                fontWeight: FontWeight.w900,
                fontSize: 15))
      ]),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/wetra_color_img.jpg",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 5),
                    rememberMe,
                    const SizedBox(height: 15),
                    GestureDetector(child: loginButton),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color.fromRGBO(203, 12, 66, 1),
                                fontWeight: FontWeight.w900,
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          isChecked = true;
        });
        emailController.text = _email;
        passwordController.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleRemeberme(bool? value) {
    print("Handle Rember Me");
    isChecked = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      },
    );
    setState(() {
      isChecked = value;
    });
  }
}
