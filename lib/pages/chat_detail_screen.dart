import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/chat_detail.dart';
import 'package:wetra_app/custom_classes/chat_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

late List data = [];

class ChatDetailScreen extends StatelessWidget {
  final ChatUser chat;
  final List<ChatDetail> chatUsers = [];
  ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  late final int selectedID = chat.id;
  late final String token = User.getUser().token;
  late final int userID = User.getUser().user.id;

  final messageText = TextEditingController();

  void addTaskAndAmount(String msgTxt, int sID, int rID) {
    final expense = ChatDetail(
        id: 1111,
        lineText: msgTxt,
        senderId: sID,
        receiverId: rID,
        imageUrl: null,
        isRead: 0);
    data.add(expense);
    //print(expense)
  }

  void setData() async {
    data = await chatDetailList();
  }

  void sendMessage(String message) async {
    final response = await http.post(Uri.parse(ApiConst.api + 'messages/send'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'chatText': message,
          'receiver': selectedID.toString(),
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to send messages');
    }
  }

  Future<List<ChatDetail>> chatDetailList() async {
    //print(selectedID);
    //print(token);
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
      body: {'selectedUser': '$selectedID'},
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      //print("MSG: $data");
      return data.map((job) => ChatDetail.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load messages');
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
        title: Text(chat.firstName + ' ' + chat.lastName),
        automaticallyImplyLeading: false,
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Expanded(
                child: FutureBuilder<List<ChatDetail>>(
                  future: chatDetailList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ChatDetail>? data = snapshot.data;
                      return ListView.builder(
                          itemCount: data?.length,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (data![index].senderId == selectedID
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (data[index].senderId == selectedID
                                        ? const Color.fromARGB(
                                            255, 241, 119, 153)
                                        : const Color.fromRGBO(
                                            255, 171, 145, 1)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    data[index].lineText,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: Text("Loading..."));
                  },
                ),
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
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
                              if (messageText.text != '') {
                                setState(() {
                                  sendMessage(messageText.text);
                                  messageText.text = '';
                                  setData();
                                });
                              }
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor:
                                const Color.fromRGBO(203, 12, 66, 1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
