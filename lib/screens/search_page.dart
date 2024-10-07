import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/screens/details.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
// import 'package:flutter_task_planner_app/ui/screens/side_bar_entry/all_task.dart';
// import 'package:flutter_task_planner_app/ui/screens/side_bar_entry/calendar.dart';
// import 'package:flutter_task_planner_app/ui/screens/side_bar_entry/highlight.dart';
// import 'package:flutter_task_planner_app/ui/screens/side_bar_entry/report.dart';
// import 'package:flutter_task_planner_app/ui/widgets/btm_nav/navigation.dart';
// import 'package:flutter_task_planner_app/ui/details.dart';
// import 'package:flutter_task_planner_app/ui/widgets/button.dart';
import 'package:flutter_task_planner_app/widgets/Tesktile.dart';
// import 'package:flutter_task_planner_app/utils/icons.dart';
// import 'package:flutter_task_planner_app/utils/theme.dart';

import '../Controller/task_controller.dart';
import '../widgets/button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _taskController = Get.put(TaskController());
  TextEditingController _searchController = TextEditingController();
  var notifyHelper;
  int currentIndex = 0;
  String searchTitle = "";

  // void onIndexChanged(int index) {
  //   setState(() {
  //     currentIndex = index;
  //     Get.to(pages[index]);
  //   });
  // }

  @override
  void initState() {
    // implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
  }

  // List pages = [
  //   AllTask(),
  //   Calendar(),
  //   Highlight(),
  //   Report(),
  // ];

  @override
  Widget build(BuildContext context) {
    print("Search Task Page");
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: LightColors.kLightYellow2,
      // using for the two columns on the top to show Time, date and add task bar
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), BlendMode.dstATop),
          image: Get.isDarkMode
              ? Image.asset("assets/Backgrounds/colorful_dark_bg.png").image
              : Image.asset("assets/Backgrounds/colorful_bg.png").image,
        )),
        child: Column(
          children: [
            _addTaskBar(),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _showResults(),
          ],
        ),
      ),
      // bottomNavigationBar: BuildNavigation(
      //   currentIndex: currentIndex,
      //   onTap: onIndexChanged, // tab switch event
      //   items: [
      //     NavigationItemModel(
      //       label: "All Task",
      //       icon: SvgIcon.layout,
      //     ),
      //     NavigationItemModel(
      //       label: "Calendar",
      //       icon: SvgIcon.calendar,
      //     ),
      //     NavigationItemModel(
      //       label: "Highlight",
      //       icon: SvgIcon.tag,
      //     ),
      //     NavigationItemModel(
      //       label: "Report",
      //       icon: SvgIcon.clipboard,
      //     ),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: menuIconColor,
      //   onPressed: () async {
      //     _taskController.getTasks();
      //   },
      //   child: const Icon(Icons.search, size: 40),
      // ),
      // float button
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //控制浮动按钮停靠在底部中间位置
    );
  }

  _showResults() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.title!.toLowerCase().contains(searchTitle.toLowerCase())) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  /* used to show the task state: Task Completed / Delete Task
  * */
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      // judge the BottomSheet height by the variable: isCompleted 0/1
      height: MediaQuery.of(context).size.height * 0.32,
      color: LightColors.kLightYellow2,
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
                  clr: LightColors.kLightYellow2,
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
          _bottomSheetButton(
            label: "Details",
            onTap: () async {
              await Get.to(() => TaskDetailPage(task: task));
              _taskController.getTasks();
            },
            clr: Colors.white,
            isClose: true,
            // set as ture
            context: context,
          ),
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
        width: MediaQuery.of(context).size.width * 0.9,
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

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Task",
            // style: headingStyle,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchTitle = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'enter the title of your task',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              MyButton(
                label: "Search",
                onTap: () {
                  String query = _searchController.text;
                  setState(() {
                    searchTitle = query;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: LightColors.kLightYellow2,
      actions: [
        // IconButton(
        //   onPressed: () {
        //     // 切换主题
        //     ThemeServices().switchTheme();
        //     notifyHelper.displayNotification(
        //       title: "Theme changed",
        //       body: Get.isDarkMode
        //           ? "Activated Light Theme"
        //           : "Activated Dark Theme",
        //     );
        //   },
        //   icon: Icon(
        //     Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_rounded,
        //     size: 20,
        //     color: Get.isDarkMode ? Colors.white : Colors.black,
        //   ),
        // ),
        SizedBox(width: 20),
      ],
    );
  }
}
