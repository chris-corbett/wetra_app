import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

List<LoginUser> userSource = [];

Future<List<LoginUser>> getFullUsers() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse('https://wyibulayin.scweb.ca/wetra/api/users'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  List<LoginUser> users = GetFullUser.fromJson(jsonDecode(response.body)).users;

  return users;
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Users'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<LoginUser>>(
          future: getFullUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading Users'));
            } else {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading users'));
              } else {
                return Center(
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          color: Colors.white,
                          child: Center(
                            child: Text(snapshot.data![index].firstName),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: snapshot.data!.length),
                );
              }
            }
          },
        ));
  }
}
