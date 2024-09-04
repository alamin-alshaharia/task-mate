import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/Db/database_helper.dart';
import 'package:flutter_task_planner_app/dates_list.dart';
import 'package:flutter_task_planner_app/screens/all_task_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/task_container.dart';
import 'package:flutter_task_planner_app/screens/create_new_task_page.dart';
import 'package:flutter_task_planner_app/widgets/back_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Controller/task_controller.dart';
import '../model/task_model.dart';
import '../widgets/ButtonItem.dart';
import '../widgets/tasktile_calender_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  final _taskController = Get.put(TaskController());
  Widget _dashedText() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: const Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  MyBackButton(
                    leftPdding: 0,
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Today',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          height: 40.0,
                          width: 120,
                          decoration: BoxDecoration(
                            color: LightColors.kDarkYellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: LightColors.kDarkYellow),
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
                        ),
                      ]),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Productive Day,User.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat.yMMMd().format(DateTime.now()),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // TaskTile(),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: DatePicker(DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: LightColors.kDarkYellow,
                        height: 100,
                        width: 80,
                        selectedTextColor: Colors.white,
                        onDateChange: (date) async {
                      setState(() {
                        _selectedDate = date;
                      });
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // _showTasks(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemCount: time.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${time[index]} ${time[index] > 8 ? 'PM' : 'AM'}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 5,
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            _dashedText(),

                            // _dashedText(),
                            _showTasks(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBootomSheet(BuildContext, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(BuildContext).size.height * 0.24
          : MediaQuery.of(BuildContext).size.height * 0.32,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          ),
          task.isCompleted == 1
              ? Container()
              : ButtonItem(
                  textColor: Colors.black54,
                  buttonColor: Colors.greenAccent,
                  onClick: () {
                    _taskController.markTaskCompleted(task.id!);
                    // DatabaseHelper.countCompletedTasks();

                    Get.back();
                  },
                  text: "Task Completed",
                  imagePath: 'assets/done.svg',
                  size: 25),
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
          SizedBox(
            height: 10,
          ),
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
    ));
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index) {
                Task task = _taskController.taskList[index];

                if (task.repeat == 'Daily') {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBootomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ),
                        ),
                      ));
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBootomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ),
                        ),
                      ));
                } else {
                  return Container();
                }
              });
        },
      ),
    );
  }
}
