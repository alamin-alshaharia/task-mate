import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/data_sync_manager.dart';
import '../../model/task_model.dart';
import 'task_bottom_sheet.dart';

class TaskTile extends StatelessWidget {
  final Task? task;

  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              autoClose: true,
              flex: 2,
              onPressed: task!.isStar == 1 ? undoStarTask : starTask,
              backgroundColor:
                  task!.isStar == 1 ? Colors.red[400]! : Colors.green[400]!,
              // backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: task!.isStar == 1 ? Icons.star_border : Icons.star,
              label: task!.isStar == 1 ? 'Undo Star' : 'Star',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: GestureDetector(
          onTap: () => TaskBottomSheet.show(context, task!, showStar: true),
          child: Container(
            padding: EdgeInsets.all(16),
            //  width: SizeConfig.screenWidth * 0.78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _getBGClr(task?.color ?? 0),
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    task!.isStar == 1
                        ? Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                // Icons.star,
                                color: Colors.yellow[500],
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                task?.title ?? "",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            task?.title ?? "",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          // "${task!.startTime} - ${task!.endTime}",
                          "${task!.startTime} - ${task!.date}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 13, color: Colors.grey[100]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      task?.description ?? "",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 0.5,
                color: Colors.grey[200]!.withOpacity(0.7),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  task!.isCompleted == 1 ? "COMPLETED" : "TODO",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void starTask(BuildContext context) async {
    try {
      final dataSyncManager = Get.find<DataSyncManager>();
      final updatedTask = Task(
        id: task!.id,
        title: task!.title,
        description: task!.description,
        date: task!.date,
        startTime: task!.startTime,
        endTime: task!.endTime,
        remind: task!.remind,
        repeat: task!.repeat,
        color: task!.color,
        isCompleted: task!.isCompleted,
        isStar: 1, // Mark as starred
        categoryId: task!.categoryId,
      );
      await dataSyncManager.toggleTaskStar(updatedTask);
    } catch (e) {
      print('Error starring task: $e');
      // Fallback to show user feedback
      Get.snackbar('Error', 'Failed to star task: $e');
    }
  }

  void undoStarTask(BuildContext context) async {
    try {
      final dataSyncManager = Get.find<DataSyncManager>();
      final updatedTask = Task(
        id: task!.id,
        title: task!.title,
        description: task!.description,
        date: task!.date,
        startTime: task!.startTime,
        endTime: task!.endTime,
        remind: task!.remind,
        repeat: task!.repeat,
        color: task!.color,
        isCompleted: task!.isCompleted,
        isStar: 0, // Remove star
        categoryId: task!.categoryId,
      );
      await dataSyncManager.toggleTaskStar(updatedTask);
    } catch (e) {
      print('Error unstarring task: $e');
      // Fallback to show user feedback
      Get.snackbar('Error', 'Failed to unstar task: $e');
    }
  }

  /* Control the color of TASK LIST */
  ColorSwatch<int> _getBGClr(int no) {
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
