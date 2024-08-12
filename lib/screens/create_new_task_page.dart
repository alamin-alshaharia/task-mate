import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/Controller/task_controller.dart';
import 'package:flutter_task_planner_app/screens/calendar_page.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:flutter_task_planner_app/widgets/back_button.dart';
import 'package:flutter_task_planner_app/widgets/my_text_field.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateNewTaskPage extends StatefulWidget {
  @override
  State<CreateNewTaskPage> createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> {
  @override
  final TaskController _taskController = Get.put(TaskController());
  final Task task = Task();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  String _endTime = "9:30 AM";
  String titleText = "";

  int _selectedCatagoryColor = 0;

  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedColor = 0;

  Widget build(BuildContext context) {
    String date = DateFormat.yMMMd().format(_selectedDate);
    double width = MediaQuery.of(context).size.width;

    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Create new task',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(
                        label: 'Title',
                        textController: titleController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: MyTextField(
                                ontap: () async {},
                                textController:
                                    TextEditingController(text: date),
                                label: "Date",
                                icon: downwardIcon),
                          ),
                          InkWell(
                              onTap: () {
                                _getDate(context);
                              },
                              child: HomePage.calendarIcon()),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: MyTextField(
                        textController: TextEditingController(text: _startTime),
                        ontap: () => _getTime(isStartTime: true),
                        label: 'Start Time',
                        icon: Icon(
                          Icons.access_time_outlined,
                          color: Colors.black26,
                        ),
                      )),
                      SizedBox(width: 40),
                      Expanded(
                        child: MyTextField(
                          label: 'End Time',
                          textController: TextEditingController(text: _endTime),
                          ontap: () => _getTime(isStartTime: false),
                          icon: Icon(
                            Icons.access_time_outlined,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: 'Description',
                    minLines: 3,
                    maxLines: 3,
                    textController: descriptionController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            spacing: 18.0,
                            children: List<Widget>.generate(3, (int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCatagoryColor = index;
                                  });
                                },
                                child: Chip(
                                  elevation: 20,
                                  label: index == 0
                                      ? Text("Personal")
                                      : index == 1
                                          ? Text("Important")
                                          : Text("Planned"),
                                  backgroundColor:
                                      _selectedCatagoryColor == index
                                          ? LightColors.kLightBlue
                                          : LightColors.kLightYellow2,
                                  labelStyle: TextStyle(
                                    color: _selectedCatagoryColor == index
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            })),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 5, left: 2),
                          child: Text(
                            "Color",
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                        Wrap(
                          children: List<Widget>.generate(4, (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, top: 7, right: 7),
                                  child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: index == 0
                                          ? Colors.red
                                          : index == 1
                                              ? Colors.blue
                                              : index == 2
                                                  ? Colors.amberAccent
                                                  : Colors.lightBlueAccent,
                                      child: _selectedColor == index
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            )
                                          : Container())),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Container(
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _validateData();
                      _addTaskToDb();
                    },
                    child: Container(
                      child: Text(
                        'Create Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      width: width - 40,
                      decoration: BoxDecoration(
                        color: LightColors.kLightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getDate(context) async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2125),
        initialDate: DateTime.now());
    if (pickDate != null) {
      setState(() {
        _selectedDate = pickDate;
      });
    }
  }

  _addTaskToDb() {
    _taskController.addTask(
        task: Task(
            color: _selectedColor,
            date: _selectedDate.toString(),
            description: descriptionController.text,
            title: titleController.text,
            endTime: _endTime,
            startTime: _startTime,
            isCompleted: 0,
            reminder: 5,
            repeat: "kdf"));
  }

  _validateData() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      _addTaskToDb();
      Get.to(CalendarPage());
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      return Get.snackbar("Warning", "All Fields are Required",
          icon: Icon(Icons.warning_amber_rounded),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: LightColors.kPalePink);
    }
  }

  _getTime({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();

    String _formatedTime = pickedTime.format(context);

    if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
        context: context);
  }
}
