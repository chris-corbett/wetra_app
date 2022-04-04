import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wetra_app/custom_classes/schedule.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

getSchedules() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse('https://wyibulayin.scweb.ca/wetra/api/schedules'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(FullSchedule.fromJson(jsonDecode(response.body)).schedules.first.start);
  //print(response.body);
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver {
  bool isAdmin = User.getUser().user.isAdmin == 0 ? false : true;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    getSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SfCalendar(view: CalendarView.month),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        visible: isAdmin ? true : false,
      ),
    );
  }
}
