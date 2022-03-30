import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wetra_app/Admin_side_pages/chat_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/Admin_side_pages/chat_user_list.dart';

import '../custom_objects/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatUser> chatUsers = [];

  @override
  void initState() {
    super.initState();
    userList();
  }

  Future<List<ChatUser>> userList() async {
    final response = await http.post(
      // API URL
      Uri.parse('https://wyibulayin.scweb.ca/wetra/api/users/all'),
      // Headers for the post request
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer 9|vsEedaNOZSDfOTC75uh44FqjR5I1ygvqnfCvcjPK',
      },
      // Encoding for the body
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ChatUser.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle, size: 30.0),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ChatUserList();
              }));
            },
          ),
        ],
      ),
      // body: GestureDetector(
      //   onTap: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return const ChatDetailScreen();
      //     }));
      //   },
      // )
      body: const Center(
        child: Text("Click on Add Button"),
      ),
    );
  }
}
