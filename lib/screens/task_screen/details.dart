import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';

import '../../model/task_model.dart';
import '../../widgets/task_widget/my_text_field.dart';

// Details page
// convert StatelessWidget to StatefulWidget by Alt + ENTER
class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailPage> {
  late Task? task = widget.task;
  final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _noteController = TextEditingController();
  List<int> reminderList = [
    5,
    10,
    15,
    20,
  ];
  List<String> repeatList = ["None", "Once", "Daily", "Weekly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    _selectedColor = task!.color!;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow2,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // Icon(Icons.task, color: _getBGClr(task?.color ?? 0)),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        task!.title!,
                        // style: headingStyle,
                      ),
                    ],
                  ),
                  // _colorPalette(),
                ],
              ),
              MyTextField(
                textController: _titleController,
                label: task!.title!,
              ),
              // MyInputField(
              //   title: "Note",
              //   hint: task!.note!,
              //   controller: _noteController,
              // ),
              // MyInputField(
              //   title: "Date",
              //   hint: task!.date!,
              //   widget: IconButton(
              //     icon: const Icon(
              //       Icons.calendar_today_outlined,
              //       color: Colors.grey,
              //     ),
              //     onPressed: () {
              //       print("Your click the Date choose function");
              //       _getDateFromUser();
              //     },
              //   ),
              // ),
              Row(
                children: [
                  // Expanded(
                  //     child: MyInputField(
                  //   title: "Start Time",
                  //   hint: task!.startTime!,
                  //   widget: IconButton(
                  //       onPressed: () {
                  //         _getTimeFromUser(isStartTime: true);
                  //       },
                  //       icon: const Icon(
                  //         Icons.access_time_rounded,
                  //         color: Colors.grey,
                  //       )),
                  // )),
                ],
              ),
              // MyInputField(
              //   title: "Remind",
              //   hint: "${task!.remind!} minutes early",
              //   widget: DropdownButton(
              //     icon: const Icon(
              //       Icons.keyboard_arrow_down,
              //       color: Colors.grey,

              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  Container(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //     default:
  //       return bluishClr;
  //   }
  // }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Color",
        //   style: titleStyle,
        // ),
        // SizedBox(
        //   height: 8.0,
        // ),
        // Wrap widget can help put things in horizontal line
        Wrap(
          // used for the horizontal layout
          children: List<Widget>.generate(4, (int index) {
            return GestureDetector(
              // make the color selectable
              onTap: () {
                setState(() {
                  // use setState() to trigger the result
                  _selectedColor = index; // save the index color
                  task?.color = _selectedColor;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.cyan,
                  // add more colors here
                  // index == 0
                  //     ? primaryClr
                  //     : index == 1
                  //         ? pinkClr
                  //         : index == 2
                  //             ? yellowClr
                  //             : Colors.deepOrange,
                  // we want to show the selected color with tick only,
                  // other should be blank (empty Container)
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      // eliminate the shadow of header banner
      backgroundColor: LightColors.kLightYellow2,
      leading: GestureDetector(
        onTap: () {
          Get.back(); // back to previous page
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          // Icon color should change according to the Theme Mode
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: const Text(
        "Task Details",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}
