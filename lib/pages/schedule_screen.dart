import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/schedule.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:wetra_app/pages/create_event_screen.dart';
import 'package:wetra_app/pages/view_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// List of all events on the calendar.
List<Event> events = [];

// Called to get the events from the api and update the calendar.
getEvents() async {
  events.clear();
  events = await getSchedules();
}

List<Event> scheduleSource = [];

Future<List<Event>> getSchedules() async {
  String token = User.getUser().token;
  final response = await http.get(
    Uri.parse(ApiConst.api + 'schedules'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // A list of all the events recieved from the api.
  List<Schedule> schedules =
      FullSchedule.fromJson(jsonDecode(response.body)).schedules;

  for (int i = 0; i < schedules.length; i++) {
    // Create temporary values to be used in the creation of the schedule source object
    DateTime tempStart =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(schedules[i].start);
    DateTime tempEnd =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(schedules[i].end);

    // Used to convert stored hex values to dart Color objects
    String hexColor = schedules[i].color.replaceAll('#', '');
    hexColor = '0xff' + hexColor;
    String hexTextColor = schedules[i].textColor.replaceAll('#', '');
    hexTextColor = '0xff' + hexTextColor;

    // The color to use for the event on the calendar
    Color tempColor = Color(int.parse(hexColor));
    Color tempTextColor = Color(int.parse(hexTextColor));

    var end = tempEnd;
    //var start = tempStart;
    var start =
        DateTime(tempStart.year, tempStart.month, tempStart.day, 0, 0, 0);

    if (end.difference(start) > const Duration(days: 1)) {
      if (tempEnd.hour != 0) {
        if (tempEnd.hour < 12) {
          end = DateTime(tempEnd.year, tempEnd.month, tempEnd.day + 1,
              12 - tempEnd.hour, 0, 0);
        } else if (tempEnd.hour >= 12) {
          end = DateTime(tempEnd.year, tempEnd.month, tempEnd.day,
              12 + tempEnd.hour, 0, 0);
        }
      }
    }

    var daysToGenerate = end.difference(start).inDays;
    //print('test $daysToGenerate - start: ${tempStart.day} - end: ${tempEnd.day}');

    if (daysToGenerate <= 1) {
      // Creates new event object and adds it to the schedule source list
      scheduleSource.add(Event(
          schedules[i].id,
          schedules[i].scheduleType != null ? schedules[i].scheduleType! : '',
          schedules[i].title,
          schedules[i].description != null ? schedules[i].description! : '',
          tempStart,
          tempEnd,
          schedules[i].assignedTo,
          schedules[i].assignedBy,
          schedules[i].isCompleted != null ? schedules[i].isCompleted! : 0,
          schedules[i].requestTimeOffId != null
              ? schedules[i].requestTimeOffId!
              : 0,
          schedules[i].confirmTimeOffId != null
              ? schedules[i].confirmTimeOffId!
              : 0,
          tempColor,
          tempTextColor,
          schedules[i].isGroup != null ? schedules[i].isGroup! : 0,
          schedules[i].allDay == 0 ? false : true));
    } else {
      var days = List.generate(daysToGenerate,
          (i) => DateTime(tempStart.year, tempStart.month, tempStart.day + i));

      for (var day in days) {
        // Creates new event object and adds it to the schedule source list
        scheduleSource.add(Event(
            schedules[i].id,
            schedules[i].scheduleType != null ? schedules[i].scheduleType! : '',
            schedules[i].title,
            schedules[i].description != null ? schedules[i].description! : '',
            day,
            day,
            schedules[i].assignedTo,
            schedules[i].assignedBy,
            schedules[i].isCompleted != null ? schedules[i].isCompleted! : 0,
            schedules[i].requestTimeOffId != null
                ? schedules[i].requestTimeOffId!
                : 0,
            schedules[i].confirmTimeOffId != null
                ? schedules[i].confirmTimeOffId!
                : 0,
            tempColor,
            tempTextColor,
            schedules[i].isGroup != null ? schedules[i].isGroup! : 0,
            schedules[i].allDay == 0 ? false : true));
      }
    }
  }

  return scheduleSource;
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver {
  bool isAdmin = User.getUser().user.isAdmin == 0 ? false : true;

  // Properties for the calendar
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Event> _eventsForDay = [];

  // Code in this method will be called whenever the schedule screen is shown for the first time.
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    getEvents();
    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {
  //       getEvents();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Visibility(
            visible: isAdmin,
            child: IconButton(
              icon: const Icon(Icons.add_circle, size: 30.0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CreateEventScreen();
                }));
              },
            ),
          )
        ],
      ),
      body: Center(
          child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(1970, 01, 01),
            lastDay: DateTime.utc(3000, 01, 01),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              _eventsForDay = events
                  .where((event) => isSameDay(event.from, selectedDay))
                  .toList(); //_getEventsForDay(selectedDay);
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
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) =>
                events.where((event) => isSameDay(event.from, day)).toList(),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _eventsForDay.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewScheduleScreen(
                        event: _eventsForDay[index],
                      );
                    }));
                  },
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    color: _eventsForDay[index].background,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(_eventsForDay[index].eventName,
                                style: TextStyle(
                                    color: _eventsForDay[index].textColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      )),
    );
  }
}

LinkedHashMap<DateTime, List<Event>> test() {
  Map<DateTime, List<Event>> kEventSource = {};

  for (var element in (scheduleSource)) {
    var daysToGenerate = element.to.difference(element.from).inDays;
    var days = List.generate(
        daysToGenerate,
        (i) => DateTime(
            element.from.year, element.from.month, element.from.day + i));

    for (var day in days) {
      kEventSource[DateTime(day.year, day.month, day.day)] =
          kEventSource[DateTime(day.year, day.month, day.day)] != null
              ? [
                  ...?kEventSource[DateTime(day.year, day.month, day.day)],
                ]
              : [element];
    }
  }

  final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(kEventSource);
  return kEvents;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

// Event class to represent the data in the calendar
class Event {
  int id;
  String scheduleType;
  String eventName;
  String description;
  DateTime from;
  DateTime to;
  int assignedTo;
  int assignedBy;
  int isComplete;
  int requestTimeOffId;
  int confirmTimeOffId;
  Color background;
  Color textColor;
  int isGroup;
  bool isAllDay;

  Event(
      this.id,
      this.scheduleType,
      this.eventName,
      this.description,
      this.from,
      this.to,
      this.assignedTo,
      this.assignedBy,
      this.isComplete,
      this.requestTimeOffId,
      this.confirmTimeOffId,
      this.background,
      this.textColor,
      this.isGroup,
      this.isAllDay);
}
