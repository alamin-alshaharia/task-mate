import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  // @override
  State<ReportPage> createState() => _ReportPageState();
}

Color bluishClr = Colors.blue;
Color primaryClr = Colors.white;
const double kDefaultPadding = 20;

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final _taskController = Get.put(TaskController());
  int currentIndex = 3;
  int totalTask = 0;
  int completedTask = 0;
  bool isCircular = true;
  ColorTween _colorTween = ColorTween(begin: bluishClr, end: Colors.green);
  double _rotation = 0.0;
  late AnimationController _controller;

  // by default first item will be selected
  int selectedIndex = 0;
  List<String> categories = ['All', 'Today', '7 day', 'This Month'];

  Future<void> _fetchAllTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchOneDayTaskStats() async {
    try {
      double totalResult = await _taskController.getOneDayTask();
      double completedResult = await _taskController.getOneDayCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchSevenDaysTaskStats() async {
    try {
      double totalResult = await _taskController.getSevenDaysTasks();
      double completedResult =
          await _taskController.getSevenDaysCompletedTasks();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchOneMonthTaskStats() async {
    try {
      double totalResult = await _taskController.getThisMonthTasks();
      double completedResult = await _taskController.getMonthCompletedTasks();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void switchFunc() {
    if (selectedIndex == 0) {
      _fetchAllTaskStats();
    } else if (selectedIndex == 1) {
      _fetchOneDayTaskStats();
    } else if (selectedIndex == 2) {
      _fetchSevenDaysTaskStats();
    } else if (selectedIndex == 3) {
      _fetchOneMonthTaskStats();
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // implement initState
    super.initState();

    _fetchAllTaskStats();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Report Task Page");

    var todoTasks = totalTask - completedTask;
    // print(todoTasks);
    var percent = (completedTask / totalTask * 100).toStringAsFixed(0);
    // print(percent);

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: LightColors.kLightYellow,
      // using for the two columns on the top to show Time, date and add task bar
      body: Column(
        children: [
          _addTaskBar(),
          const SizedBox(
            height: 10,
          ),
          // CategoryList(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    switchFunc();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    // At end item it add extra 20 right  padding
                    right: index == categories.length - 1 ? kDefaultPadding : 0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? LightColors.kBlue.withOpacity(0.95)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    categories[index],
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          index == selectedIndex ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          // buildStepProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
                  //   child: const Divider(thickness: 2),
                  // ),
                  SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: isCircular
                        ? CircularStepProgressIndicator(
                            selectedColor: bluishClr,
                            totalSteps: totalTask == 0 ? 1 : totalTask,
                            currentStep: completedTask,
                            width: 150,
                            stepSize: 9,
                            roundedCap: (_, isSelected) => isSelected,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${totalTask == 0 ? 0 : percent} %',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                                const SizedBox(height: 1.0),
                                const Text(
                                  "Efficiency",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                          )
                        : CircularStepProgressIndicator(
                            totalSteps: totalTask == 0 ? 1 : totalTask,
                            currentStep: completedTask,
                            stepSize: 20,
                            selectedColor: Colors.green,
                            unselectedColor: Colors.grey[200],
                            padding: 0,
                            selectedStepSize: 22,
                            roundedCap: (_, __) => true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${totalTask == 0 ? 0 : percent} %',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 1.0),
                                const Text(
                                  "Efficiency",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    padding: EdgeInsets.only(
                        top: 10, left: 35, right: 45, bottom: 10),
                    child: Column(
                      children: [
                        _buildStatus(
                            isCircular ? bluishClr : LightColors.kGreen,
                            completedTask,
                            'Completed Tasks'),
                        _buildStatus(
                            LightColors.kLightBlue, todoTasks, 'Todo Tasks'),
                        _buildStatus(
                            LightColors.kDarkYellow, totalTask, 'Total Tasks'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishClr,
        onPressed: () async {
          await Get.to(() => CreateNewTaskPage());
          _taskController.getTasks();
        },
        child: const Icon(Icons.update_sharp, size: 35),
        // child: const Icon(Icons.add_circle_rounded, size: 50),
      ),
      // float button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildStatus(Color color, int number, String text) {
    IconData? iconData;

    if (text.contains('Completed Tasks')) {
      iconData = Icons.check_circle;
    } else if (text.contains('Todo Tasks')) {
      iconData = Icons.list_alt;
    } else if (text.contains('Total Tasks')) {
      iconData = Icons.assignment;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        // first line text
                        text.split(' ')[0], // first line text
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$number', // second line text
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text.split(' ')[1], // second line text
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleStyle() {
    setState(() {
      isCircular = !isCircular;
    });
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // wrap Column with a container so that can add padding, margin..
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // margin left
              children: [
                // you can change the time showing format by DateFormat.yMMMd()
                Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  // style: subHeadingStyle,
                ),
                Text(
                  "Report",
                  // style: headingStyle,
                ),
              ],
            ),
          ),

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _colorTween.evaluate(_controller),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            transform: Matrix4.rotationZ(_rotation),
            child: IconButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                  _toggleStyle();
                } else {
                  _controller.forward();
                }
                setState(() {
                  _colorTween = _colorTween ==
                          ColorTween(begin: bluishClr, end: Colors.green)
                      ? ColorTween(begin: Colors.green, end: bluishClr)
                      : ColorTween(begin: bluishClr, end: Colors.green);
                  _rotation = _rotation == 0.0 ? 0.5 : 0.0;
                });
              },
              icon: Icon(
                Icons.swap_horizontal_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      // eliminate the shadow of header banner
      backgroundColor: LightColors.kLightYellow2,
      actions: [
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
