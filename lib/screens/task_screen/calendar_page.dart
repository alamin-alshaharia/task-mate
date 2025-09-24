import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/task_model.dart';
import '../../service/notification_services.dart';
import '../../widgets/task_widget/task_tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await notifyHelper.ensureInitialized();
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
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => Get.to(HomePage()),
          icon: const Icon(Icons.arrow_back)),
      // eliminate the shadow of header banner
      backgroundColor: Colors.amber[50],
      actions: [
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

  Widget _buildTimeline() {
    return Obx(() {
      // Sort and filter tasks
      final activeTasks = _taskController.taskList.toList()
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
            if (timeline.length > 1) {
              final prevTask = timeline[timeline.length - 2];
              final prevEndTime = DateTime.parse(prevTask['time'].toString())
                  .add(Duration(minutes: prevTask['duration']));
              final breakDuration =
                  startDateTime.difference(prevEndTime).inMinutes;
              if (breakDuration > 15) {
                // Only show breaks longer than 15 minutes
                timeline.insert(timeline.length - 1, {
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
        return const Center(
          child: Text(
            'No tasks for this date',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
      }

      // Build timeline ListView
      return ListView.builder(
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
                        fontWeight: FontWeight.w500,
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
                          color: isBreak
                              ? Colors.grey.shade300
                              : LightColors.kDarkYellow,
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
      );
    });
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> item) {
    final task = item['task'] as Task;
    return TaskTile(task);
  }

  Widget _buildBreakItem(Map<String, dynamic> item) {
    final duration = item['duration'] as int;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.free_breakfast, color: Colors.grey.shade600, size: 16),
          const SizedBox(width: 8),
          Text(
            'Break - $duration minutes',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getDateTime(String timeString, {bool from5am = false}) {
    try {
      final now = DateTime.now();
      final time = DateFormat.jm().parse(timeString);

      var dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If from5am is true and time is before 5 AM, add a day
      if (from5am && dateTime.hour < 5) {
        dateTime = dateTime.add(const Duration(days: 1));
      }

      return dateTime;
    } catch (e) {
      AppLogger.e("Error parsing time string '$timeString': $e");
      return DateTime.now();
    }
  }

  Color _getBGClr(int no) {
    switch (no) {
      case 0:
        return LightColors.kBlue;
      case 1:
        return LightColors.kRed;
      case 2:
        return LightColors.kDarkYellow;
      case 3:
        return Colors.deepOrange;
      default:
        return LightColors.kBlue;
    }
  }

  bool _isWeeklyTask(Task task) {
    DateTime weeklyDate = DateFormat.yMd().parse(task.date.toString());
    var weeklyTime = DateFormat("EEEE").format(weeklyDate);
    return task.repeat == 'Weekly' &&
        weeklyTime == DateFormat.EEEE().format(_selectedDate);
  }
}
