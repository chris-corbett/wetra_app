import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  // const ConversationList({ Key? key }) : super(key: key);

  String first_name;
  String last_name;
  //String background;

  ConversationList({
    required this.first_name,
    required this.last_name,
    // required this.background,
  });

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(widget.background),
                  //   maxRadius: 30,
                  // ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  Expanded(
                    child: Container(
                      color: Colors.deepOrange[300],
                      child: RichText(
                          text: TextSpan(
                              text: widget.first_name,
                              style: const TextStyle(
                                color: Color.fromRGBO(203, 12, 66, 1),
                                fontSize: 22,
                              ),
                              children: [
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                                text: widget.last_name,
                                style: const TextStyle(
                                    color: Color.fromRGBO(203, 12, 66, 1),
                                    fontSize: 22))
                          ])),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// body: Center(
//         child: FutureBuilder<List<ChatUser>>(
//           future: userList(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<ChatUser>? data = snapshot.data;
//               return ListView.builder(
//                   itemCount: data?.length,
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ConversationList(
//                       first_name: data![index].firstName,
//                       last_name: data[index].lastName,
//                       // background: data![index].background,
//                     );
//                   });
//             } else if (snapshot.hasError) {
//               return Text("${snapshot.error}");
//             }
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
