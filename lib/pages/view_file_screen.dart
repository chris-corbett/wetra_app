import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/uploaded_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;

class ViewFileScreen extends StatefulWidget {
  final UploadedFile file;

  const ViewFileScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<ViewFileScreen> createState() => _ViewFileScreenState();
}

class _ViewFileScreenState extends State<ViewFileScreen> {
  _launchUrl() async {
    String fileUrl = 'https://wyibulayin.scweb.ca';
    fileUrl += widget.file.fileUrl.replaceAll(' ', '%20');

    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  _deleteFile() async {
    String token = User.getUser().token;
    final response = await http.delete(
      Uri.parse(
          'https://wyibulayin.scweb.ca/wetra/api/files/${widget.file.id}'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('View File'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.file.fileName),
            ElevatedButton(
                onPressed: () {
                  _launchUrl();
                },
                child: const Text('View File')),
            Visibility(
              child: ElevatedButton(
                  onPressed: () {
                    _deleteFile();
                  },
                  child: const Text('Delete')),
              visible: User.getUser().user.isAdmin == 0 ? false : true,
            )
          ],
        ),
      ),
    );
  }
}
