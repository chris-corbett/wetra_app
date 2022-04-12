import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/login_user.dart';

class ViewUserScreen extends StatefulWidget {
  final LoginUser user;

  const ViewUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  String groupDropdownValue = 'None';
  String statusDropdownValue = 'Inactive';

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
        ),
        body: Form(
            key: _formKey,
            child: Scrollbar(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('Group:'),
                                const SizedBox(width: 15),
                                DropdownButton<String>(
                                  value: groupDropdownValue,
                                  items: <String>[
                                    'None',
                                    'Two',
                                    'Three',
                                    'Four',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      groupDropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Status:'),
                                const SizedBox(width: 15),
                                DropdownButton(
                                  value: statusDropdownValue,
                                  items: <String>['Inactive', 'Active']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      statusDropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Job Title',
                                labelText: 'Job Title',
                              ),
                            ),
                          ],
                        ))))));
  }
}
