import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/auth/auth_service.dart';
import 'package:flutter_task_planner_app/screens/auth/regScreen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_page.dart';
import 'component/radiobutton.dart';
import 'constant.dart';

import 'package:flutter_task_planner_app/widgets/ButtonItem.dart';
import 'package:flutter_task_planner_app/screens/auth/auth_service.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool showSpinner = false;
  AuthClass authClass = AuthClass();
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signinKey = GlobalKey<FormState>();
  final RegExp emailValidate = RegExp(
      r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");

  late String email;

  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LightColors.kRedlyGradiant,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Hello\nSign in!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 230.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, top: 120),
              child: SingleChildScrollView(
                child: Form(
                  key: _signinKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your email";
                          } else if (!emailValidate.hasMatch(value)) {
                            return "please enter a valid email";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email'),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your password";
                          }
                          if (password.length < 6) {
                            return "password must be  at least 6 characters";
                          }
                          return null;
                        },
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your password'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonItem(
                          imagePath: "assets/google.svg",
                          onClick: () => authClass.googleSignIn(context),
                          text: "Continue with Google",
                          iconData: null,
                          size: 25),
                      const SizedBox(
                        height: 30,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      RoundedButton(
                          widget: showSpinner
                              ? const CircularProgressIndicator(
                                  color: Colors.amberAccent,
                                  strokeWidth: 6,
                                )
                              : const Text(
                                  "Signin",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                          colour: Colors.lightBlueAccent,
                          onPressed: () async {
                            if (_signinKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final user =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);
                                if (user != null) {
                                  Get.to(HomePage());
                                }

                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                Get.snackbar(
                                  "Warning",
                                  e.toString(),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: LightColors.kRed,
                                  icon: Icon(Icons.warning_amber_rounded),
                                );
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                          }),

                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) => HomePage()));
                      //   },
                      //   child: Container(
                      //     height: 55,
                      //     width: 300,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         gradient: LightColors.kDeepRedlyGradiant),
                      //     child: const Center(
                      //       child: Text(
                      //         'SIGN IN',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 20,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(RegScreen());
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(

                                    ///done login page
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
