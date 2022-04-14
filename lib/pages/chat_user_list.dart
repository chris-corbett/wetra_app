import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../custom_classes/chat_user.dart';
import 'chat_detail_screen.dart';

class ChatUserList extends StatefulWidget {
  const ChatUserList({Key? key}) : super(key: key);

  @override
  State<ChatUserList> createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  //List<ChatUser> chatUsers = [];

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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("New Chat"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add_circle, size: 30.0), onPressed: () {}),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<ChatUser>>(
          future: userList(),
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
