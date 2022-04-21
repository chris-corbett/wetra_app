import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/chat_detail.dart';
import 'package:wetra_app/custom_classes/chat_user.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class ChatDetailScreen extends StatelessWidget {
  final LoginUser chat;
  final List<ChatDetail> chatUsers = [];
  ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  late final int selectedID = chat.id;
  late final String token = User.getUser().token;
  late final int userID = User.getUser().user.id;
  final messageText = TextEditingController();

  late List data = [];

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

  @override
  void dispose() {
    messageText.dispose;
    //super.dispose();
  }

  Future<List<ChatDetail>> chatDetailList() async {
    //print(selectedID);
    //print(token);
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
      body: {'selectedUser': '$selectedID'},
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      print("MSG: $data");
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
          title: Text(chat.firstName),
          automaticallyImplyLeading: false,
        ),
        body: Column(
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
                      physics: const NeverScrollableScrollPhysics(),
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
                                    ? const Color.fromARGB(255, 241, 119, 153)
                                    : const Color.fromRGBO(255, 171, 145, 1)),
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
            )),
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
                            addTaskAndAmount(
                                messageText.text, userID, selectedID);
                            print(data);
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

  void setState(Null Function() param0) {}
}
