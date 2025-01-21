import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomepageButton extends StatelessWidget {
  const HomepageButton(
      {super.key, required this.buttonTitle, required this.onpress});
  final String buttonTitle;
  final Function() onpress;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 43,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: () => Get.to(onpress),
          child: Text(buttonTitle)),
    );
  }
}
