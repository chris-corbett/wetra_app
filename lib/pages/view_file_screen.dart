import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/login_register_popup.dart';
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
    String fileUrl = UrlConst.url;
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
      Uri.parse(ApiConst.api + 'files/${widget.file.id}'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      // OtherPopups.createPopup(context, 'Error', 'There was an error deleting the file please try again later');
      throw Exception('Failed to delete file');
    } else {
      // OtherPopups.createPopup(context, 'File Deleted', 'The file has been deleted successfully');
    }

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Filename: ' + widget.file.fileName),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                  child: const Text('View File')),
            ),
            Visibility(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Delete'),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: const Text('DELETE FILE'),
                              content: const Text(
                                  'Are you sure you want to delete this file. This action cannot be undone!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'CANCEL'),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteFile();
                                    Navigator.pop(context, 'OK');
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ]),
                        );
                      })),
              visible: User.getUser().user.isAdmin == 0 ? false : true,
            ),
          ],
        ),
      ),
    );
  }
}
