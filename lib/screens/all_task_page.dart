import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/widgets/Tesktile.dart';
import 'package:flutter_task_planner_app/screens/create_new_task_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import '../Controller/task_controller.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({Key? key}) : super(key: key);

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  int currentIndex = 0;

  // by default first item will be selected
  int selectedIndex = 0;
  List categories = ['To do', 'Completed', 'All'];

  void onIndexChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // implement initState
    super.initState();

    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("All Task Page");
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.amber[50],
      // using for the two columns on the top to show Time, date and add task bar
      body: Column(
        children: [
          _addTaskBar(),

          const SizedBox(
            height: 10,
          ),
          // CategoryList(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20 / 2),
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 70,
                    // At end item it add extra 20 right  padding
                    right: index == categories.length - 1 ? 5 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? Colors.pink[100]?.withOpacity(0.95)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    categories[index],
                    style: GoogleFonts.lato(
                      fontSize: 11,
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
            height: 10,
          ),
          // Category logic
          selectedIndex == 0
              ? _showTodoTasks()
              : selectedIndex == 1
                  ? _showCompletedTasks()
                  : selectedIndex == 2
                      ? _showTasks()
                      : null,
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance

              // reminder logic
              if (task.repeat == "Once") {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]), // hours
                    int.parse(myTime.toString().split(":")[1]), // minutes
                    task);
              } else if (task.repeat == "Daily") {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.createDailyReminder(
                    int.parse(myTime.toString().split(":")[0]), // hours
                    int.parse(myTime.toString().split(":")[1]), // minutes
                    task);
              } else if (task.repeat == 'Weekly') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.repeatWeeklyNotification(
                    int.parse(myTime.toString().split(":")[0]), // hours
                    int.parse(myTime.toString().split(":")[1]), // minutes
                    task);
              }

              if (task != null) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  _showTodoTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == 0) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  _showCompletedTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index]; // pass an instance
              if (task.isCompleted == 1) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Container(); // cannot find any match date
              }
            });
      }),
    );
  }

  /* used to show the task state: Task Completed / Delete Task
  * */
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 5),
      // judge the BottomSheet height by the variable: isCompleted 0/1
      height: MediaQuery.of(context).size.height * 0.30,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          Spacer(),
          task.isCompleted == 1
              ? _bottomSheetButton(
                  label: "Undo Completed",
                  onTap: () {
                    _taskController.undoTaskCompleted(task.id!); // UPDATE
                    Get.back();
                  },
                  clr: Colors.green,
                  context: context,
                )
              : _bottomSheetButton(
                  label: "Task Completed",
                  // TODO -- Add warning message to avoid wrong selection
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!); // UPDATE
                    Get.back();
                  },
                  clr: Colors.white,
                  context: context,
                ),
          task.isStar == 1
              ? _bottomSheetButton(
                  label: "Undo TaskStar",
                  onTap: () {
                    _taskController.undoTaskStar(task.id!); // UPDATE
                    Get.back();
                  },
                  clr: Colors.green,
                  context: context,
                )
              : _bottomSheetButton(
                  label: "StarTask",
                  // TODO -- Add warning message to avoid wrong selection
                  onTap: () {
                    _taskController.markTaskStar(task.id!); // UPDATE
                    Get.back();
                  },
                  clr: Colors.white,
                  context: context,
                ),
          _bottomSheetButton(
            label: "Delete Task",
            onTap: () {
              // TODO -- Add warning message to avoid wrong deletion
              _taskController.delete(task); // DELETE
              Get.back();
            },
            clr: Colors.red[400]!,
            context: context,
          ),
          SizedBox(
            height: 22,
          ),
          // _bottomSheetButton(
          //   label: "Details",
          //   onTap: () async {
          //     await Get.to(() => CreateNewTaskPage());
          //     _taskController.getTasks();
          //   },
          //   clr: Colors.white38,
          //   isClose: true,
          //   // set as ture
          //   context: context,
          // ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[350]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            // copyWith() -- COPY ALL THE PROPERTY OF THE INSTANCE AND CHANGE SOME
            // style:
            //     isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // rebuilt the Container() in _appTaskBar
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
                  "All Task",
                  // style: headingStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: LiquidCircularProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.blue.withOpacity(0.5)),
              // valueColor: AlwaysStoppedAnimation(Colors.blueAccent[400]!),
              borderColor: Colors.blue,
              borderWidth: 5.0,
              // getTotalTask is type of Future<int> so we have to use FutureBuilder
              center: FutureBuilder<int>(
                future: _taskController.getTotalCompletedProgress(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  int result = snapshot.data ?? 0;
                  return Text(
                    result.toString() + "%",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
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
      backgroundColor: Colors.amber[50],
      actions: [
        IconButton(
            onPressed: () {
              // Logic for theme change
              // ThemeServices().switchTheme();
              notifyHelper.displayNotification(
                title: "Theme changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated Dark Theme",
              );
            },
            icon: Icon(
              // Day and moon icon should change according to the Theme Mode
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_rounded,
              size: 20,
              // Icon color should change according to the Theme Mode
              color: Get.isDarkMode ? Colors.white : Colors.black,
            )),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
