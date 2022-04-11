import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/uploaded_file.dart';

class ViewFileScreen extends StatefulWidget {
  final UploadedFile file;

  const ViewFileScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<ViewFileScreen> createState() => _ViewFileScreenState();
}

class _ViewFileScreenState extends State<ViewFileScreen> {
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
          child: Text(widget.file.fileName),
        ));
  }
}
