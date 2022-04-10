import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wetra_app/custom_classes/schedule.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/pages/create_event_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// List of all events on the calendar.
List<Event> events = [];

// Called to get the events from the api and update the calendar.
getEvents() async {
  events = await getSchedules();
}

Future<List<Event>> getSchedules() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse('https://wyibulayin.scweb.ca/wetra/api/schedules'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // A list of all the events recieved from the api.
  List<Schedule> schedules =
      FullSchedule.fromJson(jsonDecode(response.body)).schedules;

  // A list of the events to be added to the calendar.
  List<Event> scheduleSource = [];

  for (int i = 0; i < schedules.length; i++) {
    // Create temporary values to be used in the creation of the schedule source object
    DateTime tempStart =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(schedules[i].start);
    DateTime tempEnd =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(schedules[i].end);

    // Used to convert stored hex values to dart Color objects
    String hexColor = schedules[i].color.replaceAll('#', '');
    hexColor = '0xff' + hexColor;

    // The color to use for the event on the calendar
    Color tempColor = Color(int.parse(hexColor));

    // Creates new event object and adds it to the schedule source list
    scheduleSource.add(Event(schedules[i].id, schedules[i].title, tempStart,
        tempEnd, tempColor, schedules[i].allDay == 0 ? false : true));
  }

  return scheduleSource;
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver {
  bool isAdmin = User.getUser().user.isAdmin == 0 ? false : true;

  // Code in this method will be called whenever the schedule screen is shown for the first time.
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    getEvents();
    super.initState();
  }

  // Code in this method will be called whenever the schedule screen is brought back up.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getEvents();
    }
  }

  // Properties for the calendar
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        // Calendar
        child: TableCalendar(
          firstDay: DateTime.utc(1970, 01, 01),
          lastDay: DateTime.utc(3000, 01, 01),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
        ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateEventScreen()));
          },
          child: const Icon(Icons.add),
        ),
        // Only show the FAB if the user is an admin.
        visible: isAdmin ? true : false,
      ),
    );
  }
}

// Class used to add the events to the calendar
//List<Event>

// Event class to represent the data in the calendar
class Event {
  int id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Event(this.id, this.eventName, this.from, this.to, this.background,
      this.isAllDay);
}
