import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/chat_user.dart';
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

  Future<List<dynamic>> chatList() async {
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
      List data = json.decode(response.body);
      return data.map((job) => ChatUser.fromJson(job)).toList();
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
      body: FutureBuilder<List<dynamic>>(
        future: chatList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? data = snapshot.data;
            return ListView.builder(
                itemCount: data?.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: const Color.fromRGBO(255, 171, 145, 1),
                      child: ListTile(
                          title: Text(data![index].firstName +
                              ' ' +
                              data[index].lastName),
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
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }
}
