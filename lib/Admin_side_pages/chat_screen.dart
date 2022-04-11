import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wetra_app/Admin_side_pages/chat_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/Admin_side_pages/chat_user_list.dart';

import '../custom_objects/chat_detail.dart';
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
    chatList();
  }

  Future<List<ChatUser>> chatList() async {
    final response = await http.post(
      // API URL
      Uri.parse('https://wyibulayin.scweb.ca/wetra/api/messages/chatted_users'),
      // Headers for the post request
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer 9|vsEedaNOZSDfOTC75uh44FqjR5I1ygvqnfCvcjPK',
      },
      // Encoding for the body
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(json.decode(response.body));
      if (data.isNotEmpty) {
        for (int i = 0; i < data.length; i++) {
          if (data['$i'] != null) {
            Map<String, dynamic> map = data['$i'];
            //print(ChatUser.fromJson(map).firstName);
            chatUsers.add(ChatUser.fromJson(map));
          }
        }
      }

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
        child: FutureBuilder<List<ChatUser>>(
          future: chatList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatUser>? data = snapshot.data;
              return ListView.builder(
                  itemCount: data?.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Color.fromRGBO(255, 171, 145, 1),
                        child: ListTile(
                            title: Text(data![index].firstName),
                            leading: const SizedBox(
                              width: 50,
                              height: 50,
                              // child: Image.network(data[index].background),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(
                                        chat: data[index],
                                      )));
                            }));
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
