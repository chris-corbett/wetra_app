import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/user.dart';

class ViewUserScreen extends StatefulWidget {
  final LoginUser user;
  final List<Group> groups;

  const ViewUserScreen({Key? key, required this.user, required this.groups})
      : super(key: key);

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController pNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jTitleController = TextEditingController();
  final TextEditingController eContactNameController = TextEditingController();
  final TextEditingController eContactPhoneController = TextEditingController();

  late Group groupDropdownValue;
  late String statusDropdownValue;

  @override
  void initState() {
    // Initialize the Group and status dropdowns with the correct information for the user
    widget.groups.insert(
        0, const Group(id: 0, name: "No Group", createdAt: '', updatadAt: ''));
    groupDropdownValue = widget.user.groupId != null
        ? widget.groups
            .firstWhere((element) => element.id == widget.user.groupId)
        : widget.groups.first;
    statusDropdownValue = widget.user.status == 0 ? 'Inactive' : 'Active';

    // Initialize the text fields with the information for the user
    fNameController.text = widget.user.firstName;
    lNameController.text = widget.user.lastName;
    pNumberController.text =
        widget.user.phoneNumber != null ? widget.user.phoneNumber! : '';
    addressController.text =
        widget.user.address != null ? widget.user.address! : '';
    emailController.text = widget.user.email;
    jTitleController.text =
        widget.user.jobTitle != null ? widget.user.jobTitle! : '';
    eContactNameController.text =
        widget.user.emergencyName != null ? widget.user.emergencyName! : '';
    eContactPhoneController.text =
        widget.user.emergencyPhone != null ? widget.user.emergencyPhone! : '';

    super.initState();
  }

  @override
  void dispose() {
    widget.groups.removeAt(0);
    fNameController.dispose();
    lNameController.dispose();
    pNumberController.dispose();
    addressController.dispose();
    emailController.dispose();
    jTitleController.dispose();
    eContactNameController.dispose();
    eContactPhoneController.dispose();
    super.dispose();
  }

  void updateSettings() async {
    String token = User.getUser().token;
    await http.put(Uri.parse(ApiConst.api + 'users/${widget.user.id}'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: {
          'group_id': groupDropdownValue.id.toString(),
          'status': statusDropdownValue == 'Inactive' ? '0' : '1',
          'job_title': jTitleController.text,
        });
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
        ),
        body: Scrollbar(
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
                            DropdownButton<Group>(
                              value: groupDropdownValue,
                              items: widget.groups
                                  .map<DropdownMenuItem<Group>>((Group group) {
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
                            ),
                          ],
                        ),
                        Visibility(
                          visible: User.getUser().user.id != widget.user.id,
                          child: Row(
                            children: [
                              const Text('Status:'),
                              const SizedBox(width: 15),
                              DropdownButton(
                                value: statusDropdownValue,
                                items: <String>[
                                  'Inactive',
                                  'Active'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            controller: jTitleController,
                            decoration: const InputDecoration(
                              hintText: 'Job Title',
                              labelText: 'Job Title',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: fNameController,
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              labelText: 'First Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: lNameController,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              labelText: 'Last Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: pNumberController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              labelText: 'Phone Number',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: addressController,
                            decoration: const InputDecoration(
                              hintText: 'Address',
                              labelText: 'Address',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              labelText: 'Email Address',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: eContactNameController,
                            decoration: const InputDecoration(
                              hintText: 'Emergency Contact Name',
                              labelText: 'Emergency Contact Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            enabled: false,
                            controller: eContactPhoneController,
                            decoration: const InputDecoration(
                              hintText: 'Emergency Contact Phone Number',
                              labelText: 'Emergency Contact Phone Number',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                            child: const Text('Update Settings'),
                            onPressed: () {
                              updateSettings();
                            },
                          ),
                        ),
                      ],
                    )))));
  }
}
