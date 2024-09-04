import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/Db/database_helper.dart';
import 'package:flutter_task_planner_app/notes_taker/screens/home_page.dart';

import 'package:flutter_task_planner_app/screens/calendar_page.dart';

import 'package:flutter_task_planner_app/screens/report_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_task_planner_app/widgets/task_column.dart';
import 'package:flutter_task_planner_app/widgets/active_project_card.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';

import '../Controller/task_controller.dart';
import '../model/task_model.dart';
import 'create_new_task_page.dart';

class HomePage extends StatefulWidget {
  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? completedTaskCount;
  final TaskController _taskController = Get.put(TaskController());
  int totalTask = 0;
  int completedTask = 0;
  double totalProgress = .75;
  Future<void> _fetchAllTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  // void initState() {
  //   super.initState();
  //   _fetchAllTaskStats();
  //   // completedTaskCount = _taskController.getCount() as int?;
  // }
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAllTaskStats();
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.listenForChanges(_taskController.updateCount);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 220,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.menu),
                          color: LightColors.kDarkBlue,
                          iconSize: 25.0,
                        ),
                        Icon(Icons.search,
                            color: LightColors.kDarkBlue, size: 25.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 65.0,
                            lineWidth: 7.0,
                            animation: true,
                            percent: .75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: const CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 40.0,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  'Welcome',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: const Text(
                                  'To TaskMate',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => Get.to(ReportPage()),
                      child: Text("Task Manager")),
                  ElevatedButton(
                      onPressed: () => Get.to(CreateNewTaskPage()),
                      child: Text("Note  Manager"))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                subheading('My Tasks'),
                                GestureDetector(
                                  onTap: () async {
                                    Get.to(CalendarPage());
                                    _taskController.getTasks();
                                  },
                                  child: HomePage.calendarIcon(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            TaskColumn(
                              icon: Icons.alarm,
                              iconBackgroundColor: LightColors.kRed,
                              title: 'To Do',
                              subtitle: '${totalTask}tasks now. 1 started',
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            TaskColumn(
                              icon: Icons.blur_circular,
                              iconBackgroundColor: LightColors.kDarkYellow,
                              title: 'In Progress',
                              subtitle:
                                  '${totalTask - completedTask} tasks now. 1 started',
                            ),
                            const SizedBox(height: 15.0),
                            TaskColumn(
                              icon: Icons.check_circle_outline,
                              iconBackgroundColor: LightColors.kBlue,
                              title: 'Done',
                              subtitle: '${completedTask} tasks now. 1 started',
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            subheading('Active Projects'),
                            const SizedBox(height: 5.0),
                            // Row(
                            //   children: <Widget>[
                            //     ActiveProjectsCard(
                            //       cardColor: LightColors.kGreen,
                            //       loadingPercent: 0.25,
                            //       title: 'Medical App',
                            //       subtitle: '9 hours progress',
                            //     ),
                            //     const SizedBox(width: 20.0),
                            //     ActiveProjectsCard(
                            //       cardColor: LightColors.kRed,
                            //       loadingPercent: 0.6,
                            //       title: 'Making History Notes',
                            //       subtitle: '20 hours progress',
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: <Widget>[
                            //     ActiveProjectsCard(
                            //       cardColor: LightColors.kDarkYellow,
                            //       loadingPercent: 0.45,
                            //       title: 'Sports App',
                            //       subtitle: '5 hours progress',
                            //     ),
                            //     const SizedBox(width: 20.0),
                            //     ActiveProjectsCard(
                            //       cardColor: LightColors.kBlue,
                            //       loadingPercent: 0.9,
                            //       title: 'Online Flutter Course',
                            //       subtitle: '23 hours progress',
                            //     ),
                            //   ],
                            // ),
                            // _showAvtiveProject(),
                          ],
                        ),
                      ),
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

  _showAvtiveProject() {
    return Wrap(
      children: [
        Obx(
          () {
            return ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (_, index) {
                  Task task = _taskController.taskList[index];

                  return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              ActiveProjectsCard(
                                task: task,
                              )
                            ],
                          ),
                        ),
                      ));
                });
          },
        ),
      ],
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
