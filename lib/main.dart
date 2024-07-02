import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/screens/auth/WelcomeScreen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xffffb969), // status bar color
  ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: LightColors.kDarkBlue,
            displayColor: LightColors.kDarkBlue,
            fontFamily: 'Poppins'),
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
