import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:wetra_app/pages/chat_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/pages/chat_user_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<LoginUser>> chatList() async {
    String token = User.getUser().token;
    final response = await http.post(
      // API URL
      Uri.parse(ApiConst.api + 'messages/chatted_users'),
      // Headers for the post request
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      // Encoding for the body
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      // Map<String, dynamic> data =
      //     Map<String, dynamic>.from(json.decode(response.body));
      // if (data.isNotEmpty) {
      //   for (int i = 0; i < data.length; i++) {
      //     if (data['$i'] != null) {
      //       Map<String, dynamic> map = data['$i'];
      //       //print(ChatUser.fromJson(map).firstName);
      //       chatUsers.add(ChatUser.fromJson(map));
      //     }
      //   }
      // }
      List<LoginUser> chatUsers =
          GetFullUser.fromJson(jsonDecode(response.body)).users;
      // print(data.length);
      return chatUsers;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ChattedUser info = ChattedUser.fromJson(data);
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
      body: Center(
        child: FutureBuilder<List<LoginUser>>(
          future: chatList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Center(
                    child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChatDetailScreen(chat: snapshot.data![index]);
                        }));
                      },
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        child: Center(
                          child: Text(snapshot.data![index].firstName +
                              ' ' +
                              snapshot.data![index].lastName),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: snapshot.data!.length,
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
