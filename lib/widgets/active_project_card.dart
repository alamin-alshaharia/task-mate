import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../model/task_model.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color? cardColor;
  final double? loadingPercent;
  final String? title;
  final String? subtitle;
  final Task? task;

  ActiveProjectsCard({
    this.task,
    this.cardColor,
    this.loadingPercent = 30,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(15.0),
        height: 200,
        decoration: BoxDecoration(
          color: _getBGClr(task?.color ?? 0),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularPercentIndicator(
                animation: true,
                radius: 53.0,
                percent: loadingPercent!,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: Colors.white,
                center: Text(
                  '${(loadingPercent! * 100).round()}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task?.title ?? "",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' ${task!.startTime} - ${task!.endTime}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
