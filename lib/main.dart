import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/screens/auth/WelcomeScreen.dart';
import 'package:flutter_task_planner_app/screens/auth/auth_service.dart';
import 'package:flutter_task_planner_app/screens/create_new_task_page.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xffffb969), // status bar color
  ));

  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   MyApp({Key ?key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   AuthClass authClass = AuthClass();
//   // Widget currentPage = SignUpPage();
//
//   @override
//   void initState() {
//     super.initState();
//     // authClass.signOut();
//     checkLogin();
//   }
//
//   checkLogin() async {
//     String tokne = await authClass.getToken();
//     print("tokne");
//     if (tokne != null)
//       setState(() {
//         currentPage = HomePage();
//       });
//   }
//
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
      home: CreateNewTaskPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
//
// class SignUpPage {
// }
