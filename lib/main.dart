import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/latest_home_screen.dart';
// import 'package:flutter_task_planner_app/latest_calender_screen.dart';
// import 'package:flutter_task_planner_app/latest_home_screen.dart';
import 'package:flutter_task_planner_app/screens/task_screen/all_task_page.dart';
import 'package:flutter_task_planner_app/screens/auth/WelcomeScreen.dart';
import 'package:flutter_task_planner_app/screens/auth/auth_service.dart';
import 'package:flutter_task_planner_app/screens/auth/loginScreen.dart';
import 'package:flutter_task_planner_app/screens/task_screen/calendar_page.dart';
// import 'package:flutter_task_planner_app/screens/task_screen/calendar_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/report_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/test_active.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/screens/task_screen/profile.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Controller/task_controller.dart';
// import 'Db/note_database_helper.dart';
import 'package:flutter_task_planner_app/db/database_helper.dart';

import 'latest_calender_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await DatabaseHelper.instance.database;

  // Initialize notification helper
  final notifyHelper = NotifyHelper();
  await notifyHelper.initializeNotification();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize task controller
  final TaskController taskController = Get.put(TaskController());
  taskController.getTasks();

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow,
    statusBarColor: Color(0xffffb969),
  ));

  runApp(MyApp());
}
// void main() async {
//   final TaskController taskController = Get.put(TaskController());
//   WidgetsFlutterBinding.ensureInitialized();
//   // await DatabaseHelper.initDb();
//   // await GetStorage.init()
//
//   final notifyHelper = NotifyHelper();
//   notifyHelper.flutterLocalNotificationsPlugin;
//   notifyHelper.initializeNotification();
//   await DatabaseHelper.instance.database;
//   taskController.getTasks();
//   await Firebase.initializeApp();
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
//     statusBarColor: Color(0xffffb969), // status bar color
//   ));
//
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskMate by Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'),
      ),
      // home: CalendarTimelinePage(),
      home: WelcomeScreen(),
      // home: TaskTimelineScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
