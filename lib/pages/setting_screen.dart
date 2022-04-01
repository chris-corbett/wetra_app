import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/user.dart';

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
          title: const Text("Setting"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text(User.getUser().user.firstName),
        ));
  }
}
