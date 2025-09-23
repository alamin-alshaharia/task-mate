import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/auth/auth_service.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';

import '../../widgets/task_widget/button_item.dart';
import 'component/radiobutton.dart';
import 'constant.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final GlobalKey<FormState> _signinKey = GlobalKey<FormState>();
  AuthClass authClass = AuthClass();
  final RegExp emailValidate = RegExp(
      r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
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
          decoration: const BoxDecoration(gradient: LightColors.kRedlyGradiant),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Create Your\nAccount',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 170, 0, 0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
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
                          height: 10,
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
                            buttonColor: Colors.black54,
                            imagePath: "assets/google.svg",
                            onClick: () => authClass.googleSignIn(context),
                            text: "Continue with Google",
                            iconData: null,
                            size: 25),
                        const SizedBox(
                          height: 70,
                        ),
                        RoundedButton(
                            widget: showSpinner
                                ? const CircularProgressIndicator(
                                    color: Colors.amberAccent,
                                    strokeWidth: 7,
                                  )
                                : const Text("Register"),
                            colour: Colors.blueAccent,
                            onPressed: () async {
                              if (_signinKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                                  Get.to(HomePage());

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
                                }
                              }
                            }),
                        const SizedBox(
                          height: 80,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                " Have an account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "Sign in",
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
        ),
      ],
    ));
  }
}
