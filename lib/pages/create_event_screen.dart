import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/user.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String title = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isAllDay = false;

  //final eventTitleEditingController = TextEditingController();
  //DateTime selectedDate = DateTime.now();

  // Future<void> _selectedDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void createEvent() async {
    String token = User.getUser().token;
    final response = await http
        .post(Uri.parse(ApiConst.api + 'schedules'), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'XSRF-',
    }, body: {
      'title': titleController.text,
      'description': descriptionController.text,
      'start': startDate.toString(),
      'end': endDate.toString(),
      'color': '#0000ff',
      'textColor': '#ffffff',
      'assigned_to': '0',
      'scheduleType': 'task',
      'assigned_by': User.getUser().user.id.toString(),
    });

    print(response.body);
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
        title: const Text('Add Event'),
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
                                  hintText: 'Event Title',
                                  labelText: 'Event Title',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  hintText: 'Event Description',
                                  labelText: 'Event Description',
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
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ElevatedButton(
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
