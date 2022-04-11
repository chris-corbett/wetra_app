import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/chat_detail.dart';
import 'package:wetra_app/custom_classes/chat_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatUser chat;
  late final int chatID;
  final List<ChatDetail> chatUsers = [];
  ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  Future<ChatDetailList> chatList(int id) async {
    String token = User.getUser().token;
    final response = await http.post(
      // API URL
      Uri.parse('https://wyibulayin.scweb.ca/wetra/api/messages/chat'),
      // Headers for the post request
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      // Encoding for the body
      encoding: Encoding.getByName('utf-8'),
      body: {'selectedUser': id},
    );

    if (response.statusCode == 201) {
      chatID =
          ChatDetailList.fromJson(jsonDecode(response.body)).userChat.senderId;
      print("Chat ID is: $chatID");
      return ChatDetailList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load messages.');
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
        title: Text(chat.firstName),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder<List<ChatDetail>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChatDetail>? data = snapshot.data;
              return ListView.builder(
                  itemCount: data?.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Colors.deepOrange[200],
                        child: ListTile(
                          title: Text(data![index].lineText),
                          leading: const SizedBox(
                            width: 50,
                            height: 50,
                            // child: Image.network(data[index].background),
                          ),
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
