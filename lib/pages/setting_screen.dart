import 'package:flutter/material.dart';
import 'package:wetra_app/Authentication_pages/login_screen.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:wetra_app/pages/users_screen.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  LoginUser user = User.getUser().user;

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController pNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jTitleController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController eContactNameController = TextEditingController();
  final TextEditingController eContactPhoneController = TextEditingController();

  @override
  void initState() {
    fNameController.text = user.firstName;
    lNameController.text = user.lastName;
    pNumberController.text = user.phoneNumber != null ? user.phoneNumber! : '';
    addressController.text = user.address != null ? user.address! : '';
    emailController.text = user.email;
    jTitleController.text = user.jobTitle != null ? user.jobTitle! : '';
    //groupController.text = user.groupId
    eContactNameController.text =
        user.emergencyName != null ? user.emergencyName! : '';
    eContactPhoneController.text =
        user.emergencyPhone != null ? user.emergencyPhone! : '';
    super.initState();
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    super.dispose();
  }

  getGroups() async {
    String token = User.getUser().token;
    await http.get(Uri.parse('https://wyibulayin.scweb.ca/wetra/api/groups'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Scrollbar(
          child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: fNameController,
                decoration: const InputDecoration(
                  hintText: 'First Name',
                  labelText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: lNameController,
                decoration: const InputDecoration(
                  hintText: 'Last Name',
                  labelText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: pNumberController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  labelText: 'Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                enabled: false,
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                enabled: false,
                controller: jTitleController,
                decoration: const InputDecoration(
                  hintText: 'Job Title',
                  labelText: 'Job Title',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                enabled: false,
                controller: groupController,
                decoration: const InputDecoration(
                  hintText: 'Group',
                  labelText: 'Group',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: eContactNameController,
                decoration: const InputDecoration(
                  hintText: 'Emergency Contact Name',
                  labelText: 'Emergency Contact Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: eContactPhoneController,
                decoration: const InputDecoration(
                  hintText: 'Emergency Contact Phone Number',
                  labelText: 'Emergency Contact Phone Number',
                ),
              ),
            ),
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
        )),
      )),
    );
  }
}
