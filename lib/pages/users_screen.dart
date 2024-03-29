import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/pages/view_user_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

List<LoginUser> userSource = [];

class _UsersScreenState extends State<UsersScreen> {
  List<LoginUser> allUsers = [];
  List<LoginUser> _foundUsers = [];

  @override
  void initState() {
    getFullUsers();
    super.initState();
  }

  Future<List<LoginUser>> getFullUsers() async {
    String token = User.getUser().token;
    final response = await http.get(
      Uri.parse(ApiConst.api + 'users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    List<LoginUser> users =
        GetFullUser.fromJson(jsonDecode(response.body)).users;
    allUsers = users;
    return users;
  }

  Future<List<Group>> getGroups() async {
    String token = User.getUser().token;
    final response = await http
        .get(Uri.parse(ApiConst.api + 'groups'), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return FullGroup.fromJson(jsonDecode(response.body)).groups;
  }

  void _runFilter(String enteredSearch) {
    List<LoginUser> results = [];
    if (enteredSearch.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers
          .where((user) =>
              (user.firstName.toLowerCase() + ' ' + user.lastName.toLowerCase())
                  .contains(enteredSearch.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
            ),
            // CODE for the ListView -------------------------------------------------------------------------
            FutureBuilder<List<dynamic>>(
              future: Future.wait([getFullUsers(), getGroups()]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: Text('Loading Users')),
                      ),
                    ],
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading users'));
                  } else {
                    allUsers = snapshot.data![0];
                    List<Group> groups = snapshot.data![1];

                    // Used to populate the _foundUsers the first time the screen is opened
                    if (_foundUsers.isEmpty) {
                      _foundUsers = allUsers;
                    }

                    return Expanded(
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            String userGroup =
                                _foundUsers[index].groupId != 0 &&
                                        _foundUsers[index].groupId != null
                                    ? groups
                                        .firstWhere(
                                          (element) =>
                                              element.id ==
                                              _foundUsers[index].groupId,
                                          orElse: () => const Group(
                                              id: 0,
                                              name: 'No Group',
                                              createdAt: '',
                                              updatadAt: ''),
                                        )
                                        .name
                                    : 'No Group';
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ViewUserScreen(
                                        user: _foundUsers[index],
                                        groups: groups);
                                  },
                                ));
                              },
                              child: Container(
                                constraints: const BoxConstraints(
                                    maxHeight: double.infinity),
                                color: Colors.white,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text('Name: ' +
                                            _foundUsers[index].firstName +
                                            ' ' +
                                            _foundUsers[index].lastName),
                                        Text('Group: ' + userGroup),
                                        Text('Status: ' +
                                            (_foundUsers[index].status == 0
                                                ? 'Inactive'
                                                : 'Active')),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: _foundUsers.length),
                    );
                  }
                }
              },
            )
          ],
        ));
  }
}
