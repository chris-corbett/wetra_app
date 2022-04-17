import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/user.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

_pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    String token = User.getUser().token;
    File file = File(result.files.single.path!);

    // final response = await http.post(
    //   Uri.parse('https://wyibulayin.scweb.ca/wetra/api/files'),
    //   headers: <String, String>{
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer $token',
    //     'Content-Type': 'multipart/form-data',
    //   },
    //   body: jsonEncode({'file=@': file.path, 'shared_to=': '0'}),
    // );
    print(file.path);
    final request =
        http.MultipartRequest('POST', Uri.parse(ApiConst.api + 'files'));
    request.fields['group_id'] = '0';
    request.files.add(http.MultipartFile.fromString('file', file.path));
    request.send().then((response) {
      print(response.statusCode);
    });
    //print(response.body);
  } else {}
}

class _UploadFileScreenState extends State<UploadFileScreen> {
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
        body: Center(
          child: ElevatedButton(
            child: const Text('Choose a file'),
            onPressed: () {
              _pickFile();
            },
          ),
        ));
  }
}
