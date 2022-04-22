import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wetra_app/custom_classes/api_const.dart';
import 'package:wetra_app/custom_classes/group.dart';
import 'package:wetra_app/custom_classes/login_user.dart';
import 'package:wetra_app/custom_classes/user.dart';
import 'package:wetra_app/pages/schedule_screen.dart';
import 'package:http/http.dart' as http;

class ViewScheduleScreen extends StatefulWidget {
  final Event event;

  const ViewScheduleScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<ViewScheduleScreen> createState() => _ViewScheduleScreen();
}

class _ViewScheduleScreen extends State<ViewScheduleScreen> {
  Future<List<LoginUser>> getFullUsers() async {
    String token = User.getUser().token;
    final response = await http.get(
      Uri.parse(ApiConst.api + 'users'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    List<LoginUser> users =
        GetFullUser.fromJson(jsonDecode(response.body)).users;
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

  deleteSchedule() async {
    String token = User.getUser().token;
    final response = await http.delete(
        Uri.parse(ApiConst.api + 'schedules/destroy'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': widget.event.id.toString(),
          'scheduleType': widget.event.scheduleType,
        });
  }

  markComplete() async {
    String token = User.getUser().token;
    final response = await http.put(
        Uri.parse(ApiConst.api + 'schedules/update'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': widget.event.id.toString(),
          'taskStatus': 'completed',
        });
  }

  requestTimeOff() async {
    String token = User.getUser().token;
    final response = await http.put(
        Uri.parse(ApiConst.api + 'schedules/update'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': widget.event.id.toString(),
          'taskStatus': 'requestTimeOff',
        });

    //print(response.body);
  }

  confirmTimeOff(String confirm) async {
    String token = User.getUser().token;
    final response = await http.put(
        Uri.parse(ApiConst.api + 'schedules/update'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': widget.event.id.toString(),
          'taskStatus': confirm,
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
        title: const Text('View Schedule'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Scrollbar(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Name: ${widget.event.eventName}'),
                ),
                Visibility(
                  visible: widget.event.description == '' ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Description: ${widget.event.description}'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Start Time: ${widget.event.from}')),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('End Time: ${widget.event.to}')),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder<List<dynamic>>(
                    future: Future.wait([getFullUsers(), getGroups()]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading users');
                      } else {
                        if (snapshot.hasError) {
                          return const Text('Error loading users');
                        } else {
                          if (widget.event.assignedTo == 0) {
                            return const Text('Assigned to: All users');
                          } else {
                            List<LoginUser> users = snapshot.data![0];
                            List<Group> groups = snapshot.data![1];
                            if (widget.event.isGroup == 1) {
                              return Text(
                                  'Assigned to: ${groups.where((element) => element.id == widget.event.assignedTo).first.name}');
                            } else {
                              LoginUser user = users
                                  .where((element) =>
                                      element.id == widget.event.assignedTo)
                                  .first;
                              return Text(
                                  'Assigned to: ${user.firstName} ${user.lastName}');
                            }
                          }
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      'Completed: ${widget.event.isComplete == 0 ? 'false' : 'true'}'),
                ),
                Visibility(
                  visible: widget.event.scheduleType == 'task' &&
                          widget.event.isComplete == 0 &&
                          User.getUser().user.isAdmin == 1 ||
                      User.getUser().user.id == widget.event.assignedTo ||
                      widget.event.assignedTo == 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Mark Complete'),
                        onPressed: () {
                          setState(() {
                            markComplete();
                            widget.event.isComplete = 1;
                          });
                        }),
                  ),
                ),
                Visibility(
                  visible:
                      widget.event.requestTimeOffId == User.getUser().user.id &&
                          widget.event.confirmTimeOffId == 0,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Requested Time Off'),
                  ),
                ),
                Visibility(
                  visible:
                      widget.event.requestTimeOffId == User.getUser().user.id &&
                          widget.event.confirmTimeOffId != 0,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Time Off Approved'),
                  ),
                ),
                Visibility(
                  visible: User.getUser().user.id == widget.event.assignedTo &&
                      widget.event.requestTimeOffId == 0 &&
                      widget.event.confirmTimeOffId == 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Request Time Off'),
                        onPressed: () {
                          setState(() {
                            requestTimeOff();
                            widget.event.requestTimeOffId =
                                User.getUser().user.id;
                          });
                        }),
                  ),
                ),
                Visibility(
                  visible: User.getUser().user.isAdmin == 1 &&
                      widget.event.requestTimeOffId != 0 &&
                      widget.event.confirmTimeOffId == 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Confirm Time Off'),
                        onPressed: () {
                          setState(() {
                            confirmTimeOff('confirmTimeOff');
                            widget.event.confirmTimeOffId =
                                User.getUser().user.id;
                          });
                        }),
                  ),
                ),
                Visibility(
                  visible: User.getUser().user.isAdmin == 0 ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Delete Schedule'),
                        onPressed: () {
                          deleteSchedule();
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
