import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wetra_app/custom_classes/user.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool isAdmin = User.getUser().user.isAdmin == 0 ? false : true;

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
