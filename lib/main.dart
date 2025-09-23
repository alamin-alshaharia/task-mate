import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/controller/data_sync_manager.dart';
import 'package:flutter_task_planner_app/controller/profile_controller.dart';
import 'package:flutter_task_planner_app/db/database_helper.dart';
import 'package:flutter_task_planner_app/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/task_controller.dart';

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

  // Initialize profile controller
  Get.put(ProfileController());

  // Initialize centralized data sync manager
  Get.put(DataSyncManager());

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow,
    statusBarColor: Color(0xffffb969),
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: FutureBuilder<bool>(
        future: _checkOnboardingStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final bool onboardingComplete = snapshot.data ?? false;
          return onboardingComplete
              ? const HomePage()
              : const OnboardingScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> _checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('onboarding_complete') ?? false;
    } catch (e) {
      return false;
    }
  }
}
