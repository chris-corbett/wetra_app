import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_objects/chat_user.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatUser chat;
  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

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
        body: Container());
  }
}
