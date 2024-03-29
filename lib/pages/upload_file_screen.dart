import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/login_register_popup.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

List<LoginUser> users = [
  const LoginUser(
      id: 0,
      firstName: 'All',
      lastName: 'Users',
      email: '',
      createdAt: '',
      updatedAt: '',
      registeredDate: '')
];
List<Group> groups = [
  const Group(id: 0, name: 'All Groups', createdAt: '', updatadAt: '')
];
Group groupDropdownValue = groups.first;
LoginUser userDropdownValue = users.first;
late File chosenFile;

class _UploadFileScreenState extends State<UploadFileScreen> {
  final TextEditingController descriptionController = TextEditingController();

  String fileName = 'No File Selected';

  bool shareIsChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<File> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        fileName = file.uri.pathSegments.last;
      });

      chosenFile = file;
      return file;
    } else {
      return File('');
    }
  }

  uploadFile() async {
    String token = User.getUser().token;
    var dio = Dio();
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(chosenFile.path,
          filename: chosenFile.uri.pathSegments.last),
      'shared_to': shareIsChecked
          ? groupDropdownValue.id.toString()
          : userDropdownValue.id.toString(),
      'is_group': shareIsChecked ? '1' : '0',
    });

    final response =
        await dio.post('https://wyibulayin.scweb.ca/wetra/api/files',
            options: Options(
                headers: {
                  'Content-Type': 'multipart/form-data',
                  'Accept': 'application/json',
                  'Accept-Encoding': 'application/gzip',
                  'Authorization': 'Bearer $token',
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }),
            data: formData);

    if (response.statusCode != 200) {
      OtherPopups.createPopup(context, 'Error Uploading File',
          'There was an error uploading the file please try again later');
      throw Exception('Failed to upload file');
    } else {
      OtherPopups.createPopup(
          context, 'File Uploaded', 'The file has been uploaded successfully');
    }
  }

  Future<List<Group>> getGroups() async {
    String token = User.getUser().token;
    final response = await http
        .get(Uri.parse(ApiConst.api + 'groups'), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return FullGroup.fromJson(jsonDecode(response.body)).groups;
  }

  Future<List<LoginUser>> getFullUsers() async {
    String token = User.getUser().token;
    final response = await http.get(
      Uri.parse(ApiConst.api + 'users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    List<LoginUser> users =
        GetFullUser.fromJson(jsonDecode(response.body)).users;
    return users;
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
      body: Scrollbar(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
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
                CheckboxListTile(
                  title: const Text('Share to group'),
                  value: shareIsChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      shareIsChecked = value!;
                    });
                  },
                ),
                Visibility(
                  visible: shareIsChecked,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('Group:'),
                        const SizedBox(width: 15),
                        FutureBuilder<List<Group>>(
                          future: getGroups(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: Text('Loading groups'));
                            } else {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading groups'));
                              } else {
                                if (groups.length == 1) {
                                  groups.addAll(snapshot.data!);
                                }

                                return DropdownButton<Group>(
                                  value: groupDropdownValue,
                                  items: groups.map<DropdownMenuItem<Group>>(
                                      (Group group) {
                                    return DropdownMenuItem<Group>(
                                      value: group,
                                      child: Text(group.name),
                                    );
                                  }).toList(),
                                  onChanged: (Group? newValue) {
                                    setState(() {
                                      groupDropdownValue = newValue!;
                                    });
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !shareIsChecked,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('User:'),
                        const SizedBox(width: 15),
                        FutureBuilder<List<LoginUser>>(
                          future: getFullUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: Text('Loading users'));
                            } else {
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading users'));
                              } else {
                                if (users.length == 1) {
                                  users.addAll(snapshot.data!);
                                }

                                return DropdownButton<LoginUser>(
                                  value: userDropdownValue,
                                  items: users.map<DropdownMenuItem<LoginUser>>(
                                      (LoginUser user) {
                                    return DropdownMenuItem<LoginUser>(
                                      value: user,
                                      child: Text(
                                          user.firstName + ' ' + user.lastName),
                                    );
                                  }).toList(),
                                  onChanged: (LoginUser? newValue) {
                                    setState(() {
                                      userDropdownValue = newValue!;
                                    });
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Upload file'),
                    onPressed: () {
                      uploadFile();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
