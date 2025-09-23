import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_bottom_sheet.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_tile.dart';
import 'package:get/get.dart';

import '../../controller/task_controller.dart';
import '../../widgets/task_widget/button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _taskController = Get.put(TaskController());
  final TextEditingController _searchController = TextEditingController();
  NotifyHelper? notifyHelper;
  String searchTitle = "";

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    setState(() {
      AppLogger.d("Search page initialized");
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.d("Building Search Task Page");
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: LightColors.kLightYellow2,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4), BlendMode.dstATop),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Expanded _showResults() {
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
                        TaskBottomSheet.show(context, task, showStar: true);
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

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Task",
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
        SizedBox(width: 20),
      ],
    );
  }
}
