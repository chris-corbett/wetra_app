import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
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
String hourStartDropdownValue = '12';
String minuteStartDropdownValue = '00';
String hourEndDropdownValue = '12';
String minuteEndDropdownValue = '00';

Future<List<LoginUser>> getFullUsers() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse(ApiConst.api + 'users'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  List<LoginUser> users = GetFullUser.fromJson(jsonDecode(response.body)).users;
  return users;
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

class _CreateEventScreenState extends State<CreateEventScreen> {
  String title = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isAllDay = false;
  bool typeIsChecked = false;
  bool shareIsChecked = false;

  // Variables for the color pickers
  Color pickerColorBackground = Colors.blue;
  Color currentColorBackground = Colors.blue;
  Color pickerColorText = Colors.black;
  Color currentColorText = Colors.black;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void createEvent() async {
    String token = User.getUser().token;

    // Create color strings for the background and text colors
    String backgroundColor =
        '#${currentColorBackground.value.toRadixString(16).substring(2)}';
    String textColor =
        '#${currentColorText.value.toRadixString(16).substring(2)}';

    final response = await http
        .post(Uri.parse(ApiConst.api + 'schedules'), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'XSRF-',
    }, body: {
      'title': titleController.text,
      'description': descriptionController.text,
      'start': DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
              int.parse(hourStartDropdownValue),
              int.parse(minuteStartDropdownValue),
              0)
          .toString(),
      'end': typeIsChecked
          ? DateTime(
                  endDate.year,
                  endDate.month,
                  endDate.day,
                  int.parse(hourEndDropdownValue),
                  int.parse(minuteEndDropdownValue),
                  0)
              .toString()
          : DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day,
                  int.parse(hourStartDropdownValue),
                  int.parse(minuteStartDropdownValue) + 30,
                  0)
              .toString(),
      'color': backgroundColor,
      'textColor': textColor,
      'assigned_to': typeIsChecked
          ? '0'
          : shareIsChecked
              ? groupDropdownValue.id.toString()
              : userDropdownValue.id.toString(),
      'scheduleType': typeIsChecked ? 'event' : 'task',
      'is_completed': '0',
      'assigned_by': User.getUser().user.id.toString(),
      'is_group': shareIsChecked ? '1' : '0',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add Schedule'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Scrollbar(
          child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  labelText: 'Title',
                                ),
                              ),
                            ),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    CheckboxListTile(
                                      title: const Text('Create Event'),
                                      value: typeIsChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          typeIsChecked = value!;
                                        });
                                      },
                                    ),
                                    Visibility(
                                      visible: !typeIsChecked,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: TextFormField(
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                            hintText: 'Description',
                                            labelText: 'Description',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: _FormDatePicker(
                                        title: 'Start Date',
                                        date: startDate,
                                        onChanged: (value) {
                                          setState(() {
                                            startDate = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text('Start Time: '),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: DropdownButton(
                                              value: hourStartDropdownValue,
                                              items: <String>[
                                                '00',
                                                '01',
                                                '02',
                                                '03',
                                                '04',
                                                '05',
                                                '06',
                                                '07',
                                                '08',
                                                '09',
                                                '10',
                                                '11',
                                                '12',
                                                '13',
                                                '14',
                                                '15',
                                                '16',
                                                '17',
                                                '18',
                                                '19',
                                                '20',
                                                '21',
                                                '22',
                                                '23'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String hourValue) {
                                                return DropdownMenuItem<String>(
                                                  value: hourValue,
                                                  child: Text(hourValue),
                                                );
                                              }).toList(),
                                              onChanged:
                                                  (String? newHourValue) {
                                                setState(() {
                                                  hourStartDropdownValue =
                                                      newHourValue!;
                                                });
                                              }),
                                        ),
                                        const Text(':'),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: DropdownButton(
                                              value: minuteStartDropdownValue,
                                              items: <String>[
                                                '00',
                                                '10',
                                                '20',
                                                '30',
                                                '40',
                                                '50'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String minuteValue) {
                                                return DropdownMenuItem<String>(
                                                  value: minuteValue,
                                                  child: Text(minuteValue),
                                                );
                                              }).toList(),
                                              onChanged:
                                                  (String? newMinuteValue) {
                                                setState(() {
                                                  minuteStartDropdownValue =
                                                      newMinuteValue!;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: typeIsChecked,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: _FormDatePicker(
                                              title: 'End Date',
                                              date: endDate,
                                              onChanged: (value) {
                                                setState(() {
                                                  endDate = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text('End Time: '),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: DropdownButton(
                                                    value: hourEndDropdownValue,
                                                    items: <String>[
                                                      '00',
                                                      '01',
                                                      '02',
                                                      '03',
                                                      '04',
                                                      '05',
                                                      '06',
                                                      '07',
                                                      '08',
                                                      '09',
                                                      '10',
                                                      '11',
                                                      '12',
                                                      '13',
                                                      '14',
                                                      '15',
                                                      '16',
                                                      '17',
                                                      '18',
                                                      '19',
                                                      '20',
                                                      '21',
                                                      '22',
                                                      '23'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String hourValue) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: hourValue,
                                                        child: Text(hourValue),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newHourValue) {
                                                      setState(() {
                                                        hourEndDropdownValue =
                                                            newHourValue!;
                                                      });
                                                    }),
                                              ),
                                              const Text(':'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: DropdownButton(
                                                    value:
                                                        minuteEndDropdownValue,
                                                    items: <String>[
                                                      '00',
                                                      '10',
                                                      '20',
                                                      '30',
                                                      '40',
                                                      '50'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String minuteValue) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: minuteValue,
                                                        child:
                                                            Text(minuteValue),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String?
                                                        newMinuteValue) {
                                                      setState(() {
                                                        minuteEndDropdownValue =
                                                            newMinuteValue!;
                                                      });
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: !typeIsChecked,
                                      child: Column(
                                        children: [
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
                                            child: Row(
                                              children: [
                                                const Text('Group:'),
                                                const SizedBox(width: 15),
                                                FutureBuilder<List<Group>>(
                                                  future: getGroups(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child: Text(
                                                              'Loading groups'));
                                                    } else {
                                                      if (snapshot.hasError) {
                                                        return const Center(
                                                            child: Text(
                                                                'Error loading groups'));
                                                      } else {
                                                        if (groups.length ==
                                                            1) {
                                                          groups.addAll(
                                                              snapshot.data!);
                                                        }

                                                        return DropdownButton<
                                                            Group>(
                                                          value:
                                                              groupDropdownValue,
                                                          items: groups.map<
                                                              DropdownMenuItem<
                                                                  Group>>((Group
                                                              group) {
                                                            return DropdownMenuItem<
                                                                Group>(
                                                              value: group,
                                                              child: Text(
                                                                  group.name),
                                                            );
                                                          }).toList(),
                                                          onChanged: (Group?
                                                              newValue) {
                                                            setState(() {
                                                              groupDropdownValue =
                                                                  newValue!;
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
                                          Visibility(
                                            visible: !shareIsChecked,
                                            child: Row(
                                              children: [
                                                const Text('User:'),
                                                const SizedBox(width: 15),
                                                FutureBuilder<List<LoginUser>>(
                                                  future: getFullUsers(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child: Text(
                                                              'Loading users'));
                                                    } else {
                                                      if (snapshot.hasError) {
                                                        return const Center(
                                                            child: Text(
                                                                'Error loading users'));
                                                      } else {
                                                        if (users.length == 1) {
                                                          users.addAll(
                                                              snapshot.data!);
                                                        }

                                                        return DropdownButton<
                                                            LoginUser>(
                                                          value:
                                                              userDropdownValue,
                                                          items: users.map<
                                                                  DropdownMenuItem<
                                                                      LoginUser>>(
                                                              (LoginUser user) {
                                                            return DropdownMenuItem<
                                                                LoginUser>(
                                                              value: user,
                                                              child: Text(user
                                                                      .firstName +
                                                                  ' ' +
                                                                  user.lastName),
                                                            );
                                                          }).toList(),
                                                          onChanged: (LoginUser?
                                                              newValue) {
                                                            setState(() {
                                                              userDropdownValue =
                                                                  newValue!;
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
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ElevatedButton(
                                    child: const Text('Background Color'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Pick a background color'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                enableAlpha: false,
                                                labelTypes: const [],
                                                pickerColor:
                                                    pickerColorBackground,
                                                onColorChanged: (color) {
                                                  setState(() {
                                                    pickerColorBackground =
                                                        color;
                                                  });
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('Got it'),
                                                onPressed: () {
                                                  setState(() {
                                                    currentColorBackground =
                                                        pickerColorBackground;
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text('Text Color',
                                      style: TextStyle(
                                          color: currentColorText,
                                          backgroundColor:
                                              currentColorBackground)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ElevatedButton(
                                    child: const Text('Text Color'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Pick a Text color'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                enableAlpha: false,
                                                labelTypes: const [],
                                                pickerColor: pickerColorText,
                                                onColorChanged: (color) {
                                                  setState(() {
                                                    pickerColorText = color;
                                                  });
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('Got it'),
                                                onPressed: () {
                                                  setState(() {
                                                    currentColorText =
                                                        pickerColorText;
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text('Text Color',
                                      style: TextStyle(
                                          color: currentColorText,
                                          backgroundColor:
                                              currentColorBackground)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(40),
                                  ),
                                  child: const Text('Create Event'),
                                  onPressed: () {
                                    createEvent();
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ],
                        ))),
              ))),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final String title;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.title,
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
