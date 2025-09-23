import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/auth/reg_screen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:
            const BoxDecoration(gradient: LightColors.kDeepRedlyGradiant),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 210.0),
            child: GradientText(
              'TaskMate',
              style: const TextStyle(
                fontSize: 40.0,
              ),
              colors: const [
                Colors.amberAccent,
                Colors.lightBlueAccent,
                Colors.indigo,
              ],
            ),
          ),
          const SizedBox(
            height: 110,
          ),
          const Text(
            'Welcome Back',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RegScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Login with Social Media',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ), //
          const SizedBox(
            height: 20,
          ),
          // const Image(image: AssetImage('assets/google.png'),)
        ]),
      ),
    );
  }
}
