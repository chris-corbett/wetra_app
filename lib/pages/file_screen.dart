import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/uploaded_file.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/pages/upload_file_screen.dart';
import 'package:wetra_app/pages/view_file_screen.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key}) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

Future<List<UploadedFile>> getFiles() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse(ApiConst.api + 'files'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  List<UploadedFile> files = FullFile.fromJson(jsonDecode(response.body)).files;
  return files;
}

class _FileScreenState extends State<FileScreen> {
  bool isAdmin = User.getUser().user.isAdmin == 0 ? false : true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Files"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Visibility(
              visible: isAdmin,
              child: IconButton(
                icon: const Icon(Icons.add_circle, size: 30.0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UploadFileScreen();
                  }));
                },
              ),
            )
          ],
        ),
        body: FutureBuilder<List<UploadedFile>>(
          future: getFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('Loading Files')),
                  ),
                ],
              );
            } else {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading files'));
              } else {
                return Center(
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewFileScreen(
                              file: snapshot.data![index],
                            );
                          }));
                        },
                        child: Container(
                          height: 50,
                          color: Colors.white,
                          child: Center(
                            child: Text(snapshot.data![index].fileName),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: snapshot.data!.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
