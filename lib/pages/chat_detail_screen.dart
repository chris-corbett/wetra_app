import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/chat_detail.dart';
import 'package:wetra_app/custom_classes/chat_user.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatUser chat;
  final List<ChatDetail> chatUsers = [];
  ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  late final String chatID;
  late final int userID = User.getUser().user.id;
  late final String token = User.getUser().token;
  final List<ChatDetail> messages = [];
  final messageText = TextEditingController();

  List<ChatLines> msg = [];
  List<ChatLines> msgSource = [];
  List<ChatLines> msgList = [];

  getMessage() async {
    msg = await chatDetailList();
  }

  @override
  void initState() {
    //super.initState();
    getMessage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getMessage();
    }
  }

  @override
  void dispose() {
    messageText.dispose;
    //super.dispose();
  }

  Future<List<ChatLines>> chatDetailList() async {
    print(userID);
    print(chat.id);
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
      body: {'selectedUser': userID},
      encoding: Encoding.getByName('utf-8'),
    );

    List<ChatDetail> chats =
        ChatDetailList.fromJson(jsonDecode(response.body)).chatList;

    for (int i = 0; i < chats.length; i++) {
      int senderText = chats[i].senderId;
      int receiverText = chats[i].receiverId;
      String lineText = chats[i].lineText;
      print(lineText);

      msgSource.add(ChatLines(chats[i].id, senderText, receiverText, lineText));
    }

    return msgSource;
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
        body: Column(
          children: [
            Expanded(
                child: ListView.separated(
              itemCount: msgList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 25,
                  child: Center(child: Text(msgList[index].textLine)),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )

                //     FutureBuilder<List<ChatDetail>>(
                //   future: chatDetailList(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       List<ChatDetail>? data = snapshot.data;
                //       return ListView.builder(
                //           itemCount: data?.length,
                //           shrinkWrap: true,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Card(
                //                 color: Colors.deepOrange[200],
                //                 child: ListTile(
                //                   title: Text(data![index].lineText),
                //                   leading: const SizedBox(
                //                     width: 50,
                //                     height: 50,
                //                     // child: Image.network(data[index].background),
                //                   ),
                //                 ));
                //           });
                //     } else if (snapshot.hasError) {
                //       return Text("${snapshot.error}");
                //     }
                //     return const CircularProgressIndicator();
                //   },
                // )

                ),
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.grey[400],
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageText,
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            //   messages.add();
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: const Color.fromRGBO(203, 12, 66, 1),
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
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
class ChatLines {
  int id;
  int sender;
  int receiver;
  String textLine;

  ChatLines(this.id, this.sender, this.receiver, this.textLine);
}
