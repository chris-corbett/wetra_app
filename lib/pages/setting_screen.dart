import 'package:flutter/material.dart';
import 'package:wetra_app/Authentication_pages/login_screen.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:wetra_app/pages/users_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Column(
          children: [
            Visibility(
              child: ElevatedButton(
                  child: const Text('Users'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UsersScreen()));
                  }),
              visible: User.getUser().user.isAdmin == 0 ? false : true,
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        )));
  }
}
