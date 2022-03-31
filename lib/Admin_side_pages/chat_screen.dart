import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wetra_app/Admin_side_pages/chat_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/Admin_side_pages/chat_user_list.dart';

import 'package:wetra_app/custom_objects/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //List<ChattedUser> chatUsers = [];

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
      List jsonResponse = json.decode(response.body);
      jsonResponse.map((data) => ChatUser.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }

    return chatList();
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
      body: Center(
        child: FutureBuilder<List<ChatUser>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatUser>? data = snapshot.data;
              return ListView.builder(
                  itemCount: data?.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Colors.deepOrange[200],
                        child: ListTile(
                          title: Text(data![index].firstName),
                          leading: const SizedBox(
                            width: 50,
                            height: 50,
                            // child: Image.network(data[index].background),
                          ),
                          // onTap: () {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) => ChatDetailScreen(
                          //             chat: data[index],
                          //           )));
                          // }
                        ));
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
