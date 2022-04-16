import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/chat_detail.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class ChatDetailScreen extends StatelessWidget {
  final LoginUser chat;
  late final int chatID;
  final List<ChatDetail> chatUsers = [];
  ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  Future<ChatDetailList> chatList(int id) async {
    String token = User.getUser().token;
    final response = await http.post(
      // API URL
      Uri.parse(ApiConst.api + 'messages/chat'),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                        reverse: true,
                        itemCount: 5,
                        itemBuilder: (contx, index) {
                          return const Text('test');
                        }),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1)),
              height: 70,
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                            hintText: "Write your message"),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send,
                          color: Theme.of(context).primaryColor, size: 35),
                      onPressed: null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Center(
//         child: FutureBuilder<List<ChatDetail>>(
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<ChatDetail>? data = snapshot.data;
//               return ListView.builder(
//                   itemCount: data?.length,
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Card(
//                         color: Colors.deepOrange[200],
//                         child: ListTile(
//                           title: Text(data![index].lineText),
//                           leading: const SizedBox(
//                             width: 50,
//                             height: 50,
//                             // child: Image.network(data[index].background),
//                           ),
//                         ));
//                   });
//             } else if (snapshot.hasError) {
//               return Text("${snapshot.error}");
//             }
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),