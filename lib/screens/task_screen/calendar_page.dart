import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/dates_list.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/back_button.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/task_model.dart';
import '../../service/notification_services.dart';
import '../../widgets/task_widget/tasktile_calender_page.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 15),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          MyBackButton(leftPdding: 0),
          const SizedBox(height: 30.0),
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

  Widget _buildTaskList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTimeList(),
              const SizedBox(width: 20),
              _buildTasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeList() {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: time.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${time[index]} ${time[index] > 8 ? 'PM' : 'AM'}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasks() {
    return Expanded(
      flex: 5,
      child: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            _scheduleNotifications(task);
            return _buildTaskTile(task);
          },
        );
      }),
    );
  }

  Widget _buildTaskTile(Task task) {
    if (task.date == DateFormat.yMd().format(_selectedDate) ||
        task.repeat == "Daily" ||
        _isWeeklyTask(task)) {
      return AnimationConfiguration.staggeredList(
        position: _taskController.taskList.indexOf(task),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: GestureDetector(
              onTap: () => TaskBottomSheet.show(context, task, showStar: true),
              child: TaskTile(task),
            ),
          ),
        ),
      );
    }
    return Container(); // No matching date
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
      AppLogger.e(
          "Error parsing time for task ${task.id}: ${task.startTime} - $e");
    }
  }
}
