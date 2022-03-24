import 'package:flutter/material.dart';
import 'package:wetra_app/custom_objects/user.dart';
import '../Main_pages/bottom_nav_bar.dart';
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

  //FullUser fullUser = null;
  bool loginSuccess = false;

  login() {
    //var loginSuccess = false;

    //var loginSuccess;

    //userLogin(emailController.text, passwordController.text).then(loginSuccess);
    checkLogin();

    print(loginSuccess);

    // Check if test login info matches
    if (!loginSuccess) {
      incorrectInfo();
    }

    // If the user enters the correct credentials they will be logged in and brought to the home screen
    if (loginSuccess) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  checkLogin() async {
    loginSuccess =
        await userLogin(emailController.text, passwordController.text);
  }

  // Send http post to the api with the users login credentials
  Future<bool> userLogin(String email, String password) async {
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
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      //return FullUser.fromJson(jsonDecode(response.body));
      //fullUser = FullUser.fromJson(jsonDecode(response.body));
      return true;
    } else {
      return false;
    }
  }

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
        //validator: () {},
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
        //validator: () {},
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
                    const SizedBox(height: 35),
                    loginButton,
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
}
