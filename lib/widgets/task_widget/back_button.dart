import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key, this.leftPdding = 25});
  final double leftPdding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPdding, top: 5),
      child: Hero(
        tag: 'backButton',
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 23,
            color: LightColors.kDarkBlue,
          ),
        ),
      ),
    );
  }
}
