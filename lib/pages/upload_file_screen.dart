import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/user.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  final TextEditingController descriptionController = TextEditingController();

  String fileName = 'No File Selected';
  late Group groupDropdownValue;

  @override
  void initState() {
    getGroups();
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String token = User.getUser().token;
      File file = File(result.files.single.path!);

      setState(() {
        fileName = file.uri.pathSegments.last;
      });

      // final response = await http.post(
      //   Uri.parse('https://wyibulayin.scweb.ca/wetra/api/files'),
      //   headers: <String, String>{
      //     'Accept': 'application/json',
      //     'Authorization': 'Bearer $token',
      //     'Content-Type': 'multipart/form-data',
      //   },
      //   body: jsonEncode({'file=@': file.path, 'shared_to=': '0'}),
      // );

      // print(file.path);
      // final request =
      //     http.MultipartRequest('POST', Uri.parse(ApiConst.api + 'files'));
      // request.fields['group_id'] = '0';
      // request.files.add(http.MultipartFile.fromString('file', file.path));
      // request.send().then((response) {
      //   print(response.statusCode);
      // });
      //print(response.body);
    } else {}
  }

  Future<List<Group>> getGroups() async {
    String token = User.getUser().token;
    final response = await http
        .get(Uri.parse(ApiConst.api + 'groups'), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    List<Group> groups = FullGroup.fromJson(jsonDecode(response.body)).groups;
    groupDropdownValue = groups.first;
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Upload File'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Filename: $fileName'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text('Choose a file'),
                onPressed: () {
                  _pickFile();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'File Description',
                    labelText: 'File Description',
                  )),
            ),
            FutureBuilder<List<Group>>(
              future: getGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Loading groups'));
                } else {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading groups'));
                  } else {
                    List<Group> groups = snapshot.data!;
                    groups.insert(
                        0,
                        const Group(
                            id: 0,
                            name: 'All Groups',
                            createdAt: '',
                            updatadAt: ''));

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Status:'),
                        const SizedBox(width: 15),
                        DropdownButton<Group>(
                          value: groupDropdownValue,
                          items: snapshot.data
                              ?.map((group) => DropdownMenuItem(
                                  child: Text(group.name), value: group))
                              .toList(),
                          onChanged: (Group? newValue) {
                            setState(() {
                              groupDropdownValue = newValue!;
                            });
                          },
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ],
        ));
  }
}
