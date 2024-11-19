// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
//
// import 'Controller/task_controller.dart';
//
// class TaskTimelineScreen extends StatelessWidget {
//   TaskTimelineScreen({Key? key}) : super(key: key);
//   final TaskController _taskController = Get.put(TaskController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with back button and title
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(width: 8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Personal tasks',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         'You have 3 new tasks for today!',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.more_vert),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               // Calendar strip
//               _buildCalendarStrip(),
//               const SizedBox(height: 24),
//
//               // Tasks section header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Tasks',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.timeline),
//                     label: const Text('Timeline'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Timeline with tasks
//               Expanded(
//                 child: _buildTimeline(),
//               ),

// Bottom navigation
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: [
//     IconButton(
//       icon: const Icon(Icons.home, color: Colors.blue),
//       onPressed: () {},
//     ),
//     FloatingActionButton(
//       child: const Icon(Icons.add),
//       onPressed: () {},
//     ),
//     IconButton(
//       icon: const Icon(Icons.person_outline, color: Colors.grey),
//       onPressed: () {},
//     ),
//   ],
// ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
//   Widget _buildCalendarStrip() {
//     final List<Map<String, dynamic>> days = [
//       {'day': 'Sun', 'date': '24'},
//       {'day': 'Mon', 'date': '25'},
//       {'day': 'Tue', 'date': '26'},
//       {'day': 'Wed', 'date': '27'},
//       {'day': 'Thu', 'date': '28', 'isSelected': true},
//       {'day': 'Fri', 'date': '29'},
//       {'day': 'Sat', 'date': '30'},
//     ];
//
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: days.length,
//         itemBuilder: (context, index) {
//           final day = days[index];
//           final isSelected = day['isSelected'] == true;
//
//           return Container(
//             width: 50,
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.blue : Colors.transparent,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   day['day'],
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   day['date'],
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

// Widget _buildTimeline() {
//   final activeTasks = _taskController.taskList;
//   //   final List<Map<String, dynamic>> tasks = [
//   //     {
//   //       'time': '9:00 am',
//   //       'title': 'Go for a walk with dog',
//   //       'duration': '9:00 - 10:00 am',
//   //       'color': Colors.pink.shade50,
//   //     },
//   //     {
//   //       'time': '10:00 am',
//   //       'title': 'Shot on Dribbble',
//   //       'duration': '10:00 - 12:00 am',
//   //       'color': Colors.blue.shade50,
//   //     },
//   //     {
//   //       'time': '11:00 am',
//   //       'isBreak': true,
//   //     },
//   //     {
//   //       'time': '12:00 pm',
//   //       'isBreak': true,
//   //     },
//   //     {
//   //       'time': '1:00 pm',
//   //       'isBreak': true,
//   //     },
//   //     {
//   //       'time': '2:00 pm',
//   //       'title': 'Call with client',
//   //       'duration': '2:00 - 3:00 pm',
//   //       'color': Colors.orange.shade50,
//   //     },
//   //     {
//   //       'time': '3:00 pm',
//   //       'isBreak': true,
//   //     },
//   //   ];
//
//   return ListView.builder(
//     itemCount: _taskController.taskList.length,
//     itemBuilder: (context, index) {
//       // final task = Task task;
//       var task = activeTasks[index];
//       final isBreak = task['isBreak'] == true;
//
//       return IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Time column
//             SizedBox(
//               width: 80,
//               child: Text(
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//                 task.startTime.toString(),
//               ),
//             ),
//             // Timeline dot and line
//             Column(
//               children: [
//                 Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isBreak ? Colors.grey.shade300 : Colors.blue,
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: 2,
//                     color: Colors.grey.shade300,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 16),
//             // Task details
//             if (!isBreak)
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: _getBGClr(task?.color ?? 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         task.title.toString(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         " ${task.startTime.toString()} - ${task.endTime.toString()}",
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             if (isBreak) const Expanded(child: SizedBox(height: 32)),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _buildTimeline() {
//   final activeTasks = _taskController.taskList.toList()
//     ..sort((a, b) {
//       final aStartTime = a.startTime;
//       final bStartTime = b.startTime;
//       if (aStartTime != null && bStartTime != null) {
//         return aStartTime.compareTo(bStartTime);
//       } else if (aStartTime == null) {
//         return 1; // Move tasks with null startTime to the end
//       } else {
//         return -1; // Move tasks with non-null startTime to the front
//       }
//     });
//   final timeline = <Map<String, dynamic>>[];
//
//   for (final task in activeTasks) {
//     final startTimeString = task.startTime;
//     final endTimeString = task.endTime;
//
//     if (startTimeString != null && endTimeString != null) {
//       final startTime = DateFormat('HH:mm').parse(startTimeString);
//       final endTime = DateFormat('HH:mm').parse(endTimeString);
//       final now = DateTime.now();
//       final startDateTime = DateTime(
//           now.year, now.month, now.day, startTime.hour, startTime.minute);
//       final endDateTime = DateTime(
//           now.year, now.month, now.day, endTime.hour, endTime.minute);
//       final duration = endDateTime.difference(startDateTime).inMinutes;
//
//       timeline.add({
//         'time': startDateTime,
//         'title': task.title,
//         'duration': duration,
//         'color': _getBGClr(task.color ?? 2),
//       });
//
//       // Add breaks if there's a gap between tasks
//       if (timeline.isNotEmpty) {
//         final prevTask = timeline.last;
//         final prevEndTime = DateTime.parse(prevTask['time'].toString())
//             .add(Duration(minutes: prevTask['duration']));
//         final breakDuration = startDateTime.difference(prevEndTime).inMinutes;
//         if (breakDuration > 0) {
//           timeline.add({
//             'time': prevEndTime,
//             'isBreak': true,
//             'duration': breakDuration,
//           });
//         }
//       }
//     }
//   }
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/Db/database_helper.dart';
import 'package:flutter_task_planner_app/dates_list.dart';
import 'package:flutter_task_planner_app/screens/task_screen/all_task_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_container.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/back_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Controller/task_controller.dart';
import '../../model/task_model.dart';
import '../../service/notification_services.dart';
import '../../widgets/task_widget/ButtonItem.dart';
import '../../widgets/task_widget/tasktile_calender_page.dart';

class CalendarTimelinePage extends StatefulWidget {
  @override
  State<CalendarTimelinePage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarTimelinePage> {
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 15),
            // Tasks section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.timeline),
                    label: const Text('Timeline'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timeline with tasks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _buildTimeline(),
              ),
            ),
            // _buildTaskList(),
            // _buildTimeline()
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => Get.to(HomePage()),
          icon: const Icon(Icons.arrow_back)),
      // eliminate the shadow of header banner
      backgroundColor: Colors.amber[50],
      actions: [
        IconButton(
            onPressed: () {
              Task task = _taskController.taskList[4];
              print(task.title);
              notifyHelper.displayNotification(
                  title: "Theme", body: 'Theme Changed');
              notifyHelper.createDailyReminder(8, 15, task);
              // Logic for theme change
              // ThemeServices().switchTheme();
              notifyHelper.scheduledNotification(8, 20, task);
              // notifyHelper.flutterLocalNotificationsPlugin;
              print("tapped");
            },
            icon: Icon(
              // Day and moon icon should change according to the Theme Mode
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_rounded,
              size: 20,
              // Icon color should change according to the Theme Mode
              color: Get.isDarkMode ? Colors.white : Colors.black,
            )),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          _buildTodayHeader(),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat.yMMMd().format(DateTime.now()),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20.0),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildTodayHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Today',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LightColors.kDarkYellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            await Get.to(CreateNewTaskPage());
          },
          child: const Center(
            child: Text(
              ' Add task',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: LightColors.kDarkYellow,
        height: 100,
        width: 80,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  bool _isWeeklyTask(Task task) {
    DateTime weeklyDate = DateFormat.yMd().parse(task.date.toString());
    var weeklyTime = DateFormat("EEEE").format(weeklyDate);
    return task.repeat == 'Weekly' &&
        weeklyTime == DateFormat.EEEE().format(_selectedDate);
  }

  void _scheduleNotifications(Task task) {
    try {
      DateTime date = DateFormat.jm().parse(task.startTime.toString());
      var myTime = DateFormat("HH:mm").format(date);
      int hours = int.parse(myTime.split(":")[0]);
      int minutes = int.parse(myTime.split(":")[1]);

      if (task.repeat == "Once") {
        notifyHelper.scheduledNotification(hours, minutes, task);
      } else if (task.repeat == "Daily") {
        notifyHelper.createDailyReminder(hours, minutes, task);
      } else if (task.repeat == 'Weekly') {
        notifyHelper.scheduledWeeklyNotification(hours, minutes, task);
      }
    } catch (e) {
      print("Error parsing time for task ${task.id}: ${task.startTime} - $e");
    }
  }
  // void _scheduleNotifications(Task task) {
  //   DateTime date = DateFormat.jm().parse(task.startTime.toString());
  //   var myTime = DateFormat("HH:mm").format(date);
  //   int hours = int.parse(myTime.split(":")[0]);
  //   int minutes = int.parse(myTime.split(":")[1]);
  //
  //   if (task.repeat == "Once") {
  //     notifyHelper.scheduledNotification(hours, minutes, task);
  //   } else if (task.repeat == "Daily") {
  //     notifyHelper.createDailyReminder(hours, minutes, task);
  //   } else if (task.repeat == 'Weekly') {
  //     // notifyHelper.repeatWeeklyNotification(hours, minutes, task);
  //   }
  // }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
            if (task.isCompleted != 1)
              ButtonItem(
                textColor: Colors.black54,
                buttonColor: Colors.greenAccent,
                onClick: () {
                  _taskController.markTaskCompleted(task.id!);

                  Get.back();
                },
                text: "Task Completed",
                imagePath: 'assets/done.svg',
                size: 25,
              ),
            ButtonItem(
              text: "Delete Task",
              imagePath: "assets/delete.svg",
              size: 25,
              buttonColor: Colors.red.shade300,
              onClick: () {
                _taskController.delete(task);
                Get.back();
              },
            ),
            const SizedBox(height: 10),
            ButtonItem(
              imagePath: "assets/close.svg",
              text: "Close",
              size: 25,
              textColor: Colors.black,
              buttonColor: Colors.white,
              onClick: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTimeline() {
  //   return Obx(
  //     () {
  //       final activeTasks = _taskController.taskList.value.toList()
  //         ..sort((a, b) {
  //           final aStartTime = a.startTime;
  //           final bStartTime = b.startTime;
  //           if (aStartTime != null && bStartTime != null) {
  //             final aDateTime = _getDateTime(aStartTime, from5am: true);
  //             final bDateTime = _getDateTime(bStartTime, from5am: true);
  //             return aDateTime.compareTo(bDateTime);
  //           } else if (aStartTime == null) {
  //             return 1; // Move tasks with null startTime to the end
  //           } else {
  //             return -1; // Move tasks with non-null startTime to the front
  //           }
  //         });
  //       final timeline = <Map<String, dynamic>>[];
  //
  //       for (final task in activeTasks) {
  //         final startTimeString = task.startTime;
  //         final endTimeString = task.endTime;
  //
  //         if (startTimeString != null && endTimeString != null) {
  //           final startDateTime = _getDateTime(startTimeString, from5am: true);
  //           final endDateTime = _getDateTime(endTimeString, from5am: true);
  //           final duration = endDateTime.difference(startDateTime).inMinutes;
  //
  //           if (task.date == DateFormat.yMd().format(_selectedDate) ||
  //               task.repeat == "Daily" ||
  //               _isWeeklyTask(task)) {
  //             timeline.add({
  //               'time': startDateTime,
  //               'title': task.title,
  //               'complete': task.isCompleted,
  //               'duration': duration,
  //               'color': _getBGClr(task.color ?? 2),
  //             });
  //
  //             // Add breaks if there's a gap between tasks
  //             if (timeline.isNotEmpty) {
  //               final prevTask = timeline.last;
  //               final prevEndTime = DateTime.parse(prevTask['time'].toString())
  //                   .add(Duration(minutes: prevTask['duration']));
  //               final breakDuration =
  //                   startDateTime.difference(prevEndTime).inMinutes;
  //               if (breakDuration > 0) {
  //                 timeline.add({
  //                   'time': prevEndTime,
  //                   'isBreak': true,
  //                   'duration': breakDuration,
  //                 });
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       return ListView.builder(
  //         itemCount: timeline.length,
  //         itemBuilder: (context, index) {
  //           final item = timeline[index];
  //           final isBreak = item['isBreak'] == true;
  //
  //           return IntrinsicHeight(
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 // Time column
  //                 SizedBox(
  //                   width: 80,
  //                   child: Text(
  //                     style: const TextStyle(
  //                       color: Colors.grey,
  //                       fontSize: 14,
  //                     ),
  //                     DateFormat('h:mm a').format(item['time']),
  //                   ),
  //                 ),
  //                 // Timeline dot and line
  //                 Column(
  //                   children: [
  //                     Container(
  //                       width: 12,
  //                       height: 12,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: isBreak ? Colors.grey.shade300 : Colors.blue,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         width: 2,
  //                         color: Colors.grey.shade300,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 16),
  //                 // Task details
  //                 if (!isBreak)
  //                   Expanded(
  //                     child: GestureDetector(
  //                       onTap: () => _showBottomSheet(
  //                           context, _taskController.taskList.value[index]),
  //                       child: Container(
  //                         margin: const EdgeInsets.only(bottom: 16),
  //                         padding: const EdgeInsets.all(16),
  //                         decoration: BoxDecoration(
  //                           color: item['color'],
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   item['title'],
  //                                   style: const TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                                 const SizedBox(height: 4),
  //                                 Text(
  //                                   "${DateFormat('h:mm a').format(item['time'])} - ${DateFormat('h:mm a').format(DateTime.parse(item['time'].toString()).add(Duration(minutes: item['duration']!)))}",
  //                                   style: TextStyle(
  //                                     color: Colors.grey[600],
  //                                     fontSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Container(
  //                                   margin:
  //                                       EdgeInsets.symmetric(horizontal: 10),
  //                                   height: 60,
  //                                   width: 0.5,
  //                                   color: Colors.grey[200]!.withOpacity(0.7),
  //                                 ),
  //                                 RotatedBox(
  //                                   quarterTurns: 3,
  //                                   child: Text(
  //                                     item['complete'] == 1
  //                                         ? "COMPLETED"
  //                                         : "TODO",
  //                                     style: GoogleFonts.lato(
  //                                       textStyle: TextStyle(
  //                                         fontSize: 10,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: item['complete'] == 1
  //                                             ? Colors.green
  //                                             : Colors.red,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //
  //                 if (isBreak) const Expanded(child: SizedBox(height: 32)),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  // Widget _buildTimeline() {
  //   final activeTasks = _taskController.taskList.toList()
  //     ..sort((a, b) {
  //       final aStartTime = a.startTime;
  //       final bStartTime = b.startTime;
  //       if (aStartTime != null && bStartTime != null) {
  //         final aDateTime = _getDateTime(aStartTime, from5am: true);
  //         final bDateTime = _getDateTime(bStartTime, from5am: true);
  //         return aDateTime.compareTo(bDateTime);
  //       } else if (aStartTime == null) {
  //         return 1; // Move tasks with null startTime to the end
  //       } else {
  //         return -1; // Move tasks with non-null startTime to the front
  //       }
  //     });
  //   final timeline = <Map<String, dynamic>>[];
  //
  //   for (final task in activeTasks) {
  //     final startTimeString = task.startTime;
  //     final endTimeString = task.endTime;
  //
  //     if (startTimeString != null && endTimeString != null) {
  //       final startDateTime = _getDateTime(startTimeString, from5am: true);
  //       final endDateTime = _getDateTime(endTimeString, from5am: true);
  //       final duration = endDateTime.difference(startDateTime).inMinutes;
  //
  //       if (task.date == DateFormat.yMd().format(_selectedDate) ||
  //           task.repeat == "Daily" ||
  //           _isWeeklyTask(task)) {
  //         timeline.add({
  //           'time': startDateTime,
  //           'title': task.title,
  //           'complete': task.isCompleted,
  //           'duration': duration,
  //           'color': _getBGClr(task.color ?? 2),
  //         });
  //
  //         // Add breaks if there's a gap between tasks
  //         if (timeline.isNotEmpty) {
  //           final prevTask = timeline.last;
  //           final prevEndTime = DateTime.parse(prevTask['time'].toString())
  //               .add(Duration(minutes: prevTask['duration']));
  //           final breakDuration =
  //               startDateTime.difference(prevEndTime).inMinutes;
  //           if (breakDuration > 0) {
  //             timeline.add({
  //               'time': prevEndTime,
  //               'isBreak': true,
  //               'duration': breakDuration,
  //             });
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //   return ListView.builder(
  //     itemCount: timeline.length,
  //     itemBuilder: (context, index) {
  //       final item = timeline[index];
  //       final isBreak = item['isBreak'] == true;
  //
  //       return IntrinsicHeight(
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             // Time column
  //             SizedBox(
  //               width: 80,
  //               child: Text(
  //                 style: const TextStyle(
  //                   color: Colors.grey,
  //                   fontSize: 14,
  //                 ),
  //                 DateFormat('h:mm a').format(item['time']),
  //               ),
  //             ),
  //             // Timeline dot and line
  //             Column(
  //               children: [
  //                 Container(
  //                   width: 12,
  //                   height: 12,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: isBreak ? Colors.grey.shade300 : Colors.blue,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     width: 2,
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(width: 16),
  //             // Task details
  //             if (!isBreak)
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => _showBottomSheet(context, task),
  //                   child: Container(
  //                     margin: const EdgeInsets.only(bottom: 16),
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: item['color'],
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               item['title'],
  //                               style: const TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               "${DateFormat('h:mm a').format(item['time'])} - ${DateFormat('h:mm a').format(DateTime.parse(item['time'].toString()).add(Duration(minutes: item['duration']!)))}",
  //                               style: TextStyle(
  //                                 color: Colors.grey[600],
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               height: 60,
  //                               width: 0.5,
  //                               color: Colors.grey[200]!.withOpacity(0.7),
  //                             ),
  //                             RotatedBox(
  //                               quarterTurns: 3,
  //                               child: Text(
  //                                 item['complete'] == 1 ? "COMPLETED" : "TODO",
  //                                 style: GoogleFonts.lato(
  //                                   textStyle: TextStyle(
  //                                     fontSize: 10,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: item['complete'] == 1
  //                                         ? Colors.green
  //                                         : Colors.red,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //             if (isBreak) const Expanded(child: SizedBox(height: 32)),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  // Widget _buildTimeline() {
  //   Task task = _taskController.taskList[index];
  //   final activeTasks = _taskController.taskList.toList()
  //     ..sort((a, b) {
  //       final aStartTime = a.startTime;
  //       final bStartTime = b.startTime;
  //       if (aStartTime != null && bStartTime != null) {
  //         final aDateTime = _getDateTime(aStartTime, from5am: true);
  //         final bDateTime = _getDateTime(bStartTime, from5am: true);
  //         return aDateTime.compareTo(bDateTime);
  //       } else if (aStartTime == null) {
  //         return 1; // Move tasks with null startTime to the end
  //       } else {
  //         return -1; // Move tasks with non-null startTime to the front
  //       }
  //     });
  //   final timeline = <Map<String, dynamic>>[];
  //
  //   for (final task in activeTasks) {
  //     final startTimeString = task.startTime;
  //     final endTimeString = task.endTime;
  //
  //     if (startTimeString != null && endTimeString != null) {
  //       final startDateTime = _getDateTime(startTimeString, from5am: true);
  //       final endDateTime = _getDateTime(endTimeString, from5am: true);
  //       final duration = endDateTime.difference(startDateTime).inMinutes;
  //
  //       timeline.add({
  //         'time': startDateTime,
  //         'title': task.title,
  //         'duration': duration,
  //         'color': _getBGClr(task.color ?? 2),
  //       });
  //
  //       // Add breaks if there's a gap between tasks
  //       if (timeline.isNotEmpty) {
  //         final prevTask = timeline.last;
  //         final prevEndTime = DateTime.parse(prevTask['time'].toString())
  //             .add(Duration(minutes: prevTask['duration']));
  //         final breakDuration = startDateTime.difference(prevEndTime).inMinutes;
  //         if (breakDuration > 0) {
  //           timeline.add({
  //             'time': prevEndTime,
  //             'isBreak': true,
  //             'duration': breakDuration,
  //           });
  //         }
  //       }
  //     }
  //   }
  //   if (task.date == DateFormat.yMd().format(_selectedDate) ||
  //       task.repeat == "Daily" ||
  //       _isWeeklyTask(task)) {
  //     return ListView.builder(
  //       itemCount: timeline.length,
  //       itemBuilder: (context, index) {
  //         final item = timeline[index];
  //         final isBreak = item['isBreak'] == true;
  //
  //         return IntrinsicHeight(
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               // Time column
  //               SizedBox(
  //                 width: 80,
  //                 child: Text(
  //                   style: const TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 14,
  //                   ),
  //                   DateFormat('h:mm a').format(item['time']),
  //                 ),
  //               ),
  //               // Timeline dot and line
  //               Column(
  //                 children: [
  //                   Container(
  //                     width: 12,
  //                     height: 12,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: isBreak ? Colors.grey.shade300 : Colors.blue,
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       width: 2,
  //                       color: Colors.grey.shade300,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(width: 16),
  //               // Task details
  //               if (!isBreak)
  //                 Expanded(
  //                   child: Container(
  //                     margin: const EdgeInsets.only(bottom: 16),
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: item['color'],
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           item['title'],
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           "${DateFormat('h:mm a').format(item['time'])} - ${DateFormat('h:mm a').format(DateTime.parse(item['time'].toString()).add(Duration(minutes: item['duration']!)))}",
  //                           style: TextStyle(
  //                             color: Colors.grey[600],
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               if (isBreak) const Expanded(child: SizedBox(height: 32)),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }
  // Widget _buildTimeline() {
  //   return Obx(
  //     () {
  //       final activeTasks = _taskController.taskList.value.toList()
  //         ..sort((a, b) {
  //           final aStartTime = a.startTime;
  //           final bStartTime = b.startTime;
  //           if (aStartTime != null && bStartTime != null) {
  //             final aDateTime = _getDateTime(aStartTime, from5am: true);
  //             final bDateTime = _getDateTime(bStartTime, from5am: true);
  //             return aDateTime.compareTo(bDateTime);
  //           } else if (aStartTime == null) {
  //             return 1; // Move tasks with null startTime to the end
  //           } else {
  //             return -1; // Move tasks with non-null startTime to the front
  //           }
  //         });
  //       final timeline = <Map<String, dynamic>>[];
  //
  //       for (final task in activeTasks) {
  //         final startTimeString = task.startTime;
  //         final endTimeString = task.endTime;
  //
  //         if (startTimeString != null && endTimeString != null) {
  //           final startDateTime = _getDateTime(startTimeString, from5am: true);
  //           final endDateTime = _getDateTime(endTimeString, from5am: true);
  //           final duration = endDateTime.difference(startDateTime).inMinutes;
  //
  //           if (task.date == DateFormat.yMd().format(_selectedDate) ||
  //               task.repeat == "Daily" ||
  //               _isWeeklyTask(task)) {
  //             timeline.add({
  //               'time': startDateTime,
  //               'title': task.title,
  //               'complete': task.isCompleted,
  //               'duration': duration,
  //               'color': _getBGClr(task.color ?? 2),
  //             });
  //
  //             // Add breaks if there's a gap between tasks
  //             if (timeline.isNotEmpty) {
  //               final prevTask = timeline.last;
  //               final prevEndTime = DateTime.parse(prevTask['time'].toString())
  //                   .add(Duration(minutes: prevTask['duration']));
  //               final breakDuration =
  //                   startDateTime.difference(prevEndTime).inMinutes;
  //               if (breakDuration > 0) {
  //                 timeline.add({
  //                   'time': prevEndTime,
  //                   'isBreak': true,
  //                   'duration': breakDuration,
  //                 });
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       return Expanded(
  //         child: ListView.builder(
  //           itemCount: timeline.length,
  //           itemBuilder: (context, index) {
  //             final item = timeline[index];
  //             final isBreak = item['isBreak'] == true;
  //
  //             return IntrinsicHeight(
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   // Time column
  //                   SizedBox(
  //                     width: 80,
  //                     child: Text(
  //                       style: const TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 14,
  //                       ),
  //                       DateFormat('h:mm a').format(item['time']),
  //                     ),
  //                   ),
  //                   // Timeline dot and line
  //                   Column(
  //                     children: [
  //                       Container(
  //                         width: 12,
  //                         height: 12,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: isBreak ? Colors.grey.shade300 : Colors.blue,
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: Container(
  //                           // width: 2,
  //                           color: Colors.grey.shade300,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(width: 16),
  //                   // Task details
  //                   if (!isBreak)
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () => _showBottomSheet(
  //                             context, _taskController.taskList.value[index]),
  //                         child: Expanded(
  //                           child: Container(
  //                             margin: const EdgeInsets.only(bottom: 16),
  //                             padding: const EdgeInsets.all(16),
  //                             decoration: BoxDecoration(
  //                               color: item['color'],
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       item['title'],
  //                                       style: const TextStyle(
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 4),
  //                                     Text(
  //                                       "${DateFormat('h:mm a').format(item['time'])} - ${DateFormat('h:mm a').format(DateTime.parse(item['time'].toString()).add(Duration(minutes: item['duration']!)))}",
  //                                       style: TextStyle(
  //                                         color: Colors.grey[600],
  //                                         fontSize: 14,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       margin: EdgeInsets.symmetric(
  //                                           horizontal: 10),
  //                                       height: 60,
  //                                       width: 0.5,
  //                                       color:
  //                                           Colors.grey[200]!.withOpacity(0.7),
  //                                     ),
  //                                     RotatedBox(
  //                                       quarterTurns: 3,
  //                                       child: Obx(
  //                                         () {
  //                                           final task = _taskController
  //                                               .taskList.value[index];
  //                                           return Text(
  //                                             task.isCompleted != 0
  //                                                 ? "COMPLETED"
  //                                                 : "TODO",
  //                                             style: GoogleFonts.lato(
  //                                               textStyle: TextStyle(
  //                                                 fontSize: 10,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color:
  //                                                     task.isCompleted != null
  //                                                         ? Colors.green
  //                                                         : Colors.red,
  //                                               ),
  //                                             ),
  //                                           );
  //                                         },
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                   if (isBreak) const Expanded(child: SizedBox(height: 32)),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildTimeline() {
    return Obx(() {
      // Sort and filter tasks
      final activeTasks = _taskController.taskList.value.toList()
        ..sort((a, b) {
          final aStartTime = a.startTime;
          final bStartTime = b.startTime;
          if (aStartTime != null && bStartTime != null) {
            final aDateTime = _getDateTime(aStartTime, from5am: true);
            final bDateTime = _getDateTime(bStartTime, from5am: true);
            return aDateTime.compareTo(bDateTime);
          } else if (aStartTime == null) {
            return 1; // Move tasks with null startTime to the end
          } else {
            return -1; // Move tasks with non-null startTime to the front
          }
        });

      // Create timeline
      final timeline = <Map<String, dynamic>>[];

      for (final task in activeTasks) {
        final startTimeString = task.startTime;
        final endTimeString = task.endTime;

        if (startTimeString != null && endTimeString != null) {
          final startDateTime = _getDateTime(startTimeString, from5am: true);
          final endDateTime = _getDateTime(endTimeString, from5am: true);
          final duration = endDateTime.difference(startDateTime).inMinutes;

          if (task.date == DateFormat.yMd().format(_selectedDate) ||
              task.repeat == "Daily" ||
              _isWeeklyTask(task)) {
            timeline.add({
              'time': startDateTime,
              'title': task.title,
              'complete': task.isCompleted,
              'duration': duration,
              'color': _getBGClr(task.color ?? 2),
              'task': task, // Store the full task object
            });

            // Add breaks if there's a gap between tasks
            if (timeline.isNotEmpty) {
              final prevTask = timeline.last;
              final prevEndTime = DateTime.parse(prevTask['time'].toString())
                  .add(Duration(minutes: prevTask['duration']));
              final breakDuration =
                  startDateTime.difference(prevEndTime).inMinutes;
              if (breakDuration > 0) {
                timeline.add({
                  'time': prevEndTime,
                  'isBreak': true,
                  'duration': breakDuration,
                });
              }
            }
          }
        }
      }

      // Handle empty timeline
      if (timeline.isEmpty) {
        return Center(
          child: Text(
            'No tasks for this date',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      // Build timeline ListView
      return Expanded(
        child: ListView.builder(
          itemCount: timeline.length,
          itemBuilder: (context, index) {
            final item = timeline[index];
            final isBreak = item['isBreak'] == true;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Time column
                    SizedBox(
                      width: 80,
                      child: Text(
                        DateFormat('h:mm a').format(item['time']),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Timeline dot and line
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isBreak ? Colors.grey.shade300 : Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Task or Break content
                    Expanded(
                      child: !isBreak
                          ? _buildTaskItem(context, item)
                          : _buildBreakItem(item),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

// Separate method for task item
  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context, item['task']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item['color'],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${DateFormat('h:mm a').format(item['time'])} - ${DateFormat('h:mm a').format(DateTime.parse(item['time'].toString()).add(Duration(minutes: item['duration'])))}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildTaskStatus(item),
          ],
        ),
      ),
    );
  }

// Separate method for task status
  Widget _buildTaskStatus(Map<String, dynamic> item) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          width: 0.5,
          color: Colors.grey[200]!.withOpacity(0.7),
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            item['complete'] != 0 ? "COMPLETED" : "TODO",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: item['complete'] != 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

// Break item method
  Widget _buildBreakItem(Map<String, dynamic> item) {
    return SizedBox(
      height: 32,
      child: Text(
        'Break (${item['duration']} mins)',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.lightBlueAccent;
      default:
        return Colors.blueAccent;
    }
  }
}

DateTime _getDateTime(String timeString, {bool from5am = false}) {
  final now = DateTime.now();
  final timeOfDay = DateFormat('HH:mm').parse(timeString);
  if (from5am) {
    final fiveAm = DateTime(now.year, now.month, now.day, 5, 0);
    return fiveAm
        .add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
  } else {
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}
