import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/settings/settings_screen.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/home_page/setting_dialouge.dart';
import 'package:get/get.dart';

import '../../../controller/profile_controller.dart';
import '../../../screens/task_screen/all_task_page.dart';
import '../../../screens/task_screen/calendar_page.dart';
import '../../../screens/task_screen/profile.dart';
import '../../../screens/task_screen/report_page.dart';
import '../../../theme/colors/light_colors.dart';

class MySlider extends StatelessWidget {
  MySlider({
    super.key,
  });
  final ProfileController _profileController = Get.put(ProfileController());

  /// Icons
  final List<IconData> icons = [
    // CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.doc_richtext,
    CupertinoIcons.calendar_circle_fill,
    CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  final List<String> texts = [
    // "Home",
    "Profile",
    "All Task",
    "Task Calender",
    "Task Report",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(gradient: LightColors.brownGradient),
      child: Obx(() {
        final profile = _profileController.profile.value;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profile.imageData != null
                  ? MemoryImage(profile.imageData!)
                  : const AssetImage('assets/images/avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 8),
            Text(
              profile.name ?? "User Name",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              profile.profession ?? "Profession",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 10,
              ),
              width: double.infinity,
              height: 400,
              child: ListView.builder(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () {
                      switch (i) {
                        case 0:
                          // Navigate to Profile Edit Page
                          Get.to(() => ProfilePage());
                          break;
                        case 1:
                          Get.to(() => AllTaskPage());
                          break;
                        case 2:
                          Get.to(() => CalendarPage());
                          break;
                        case 3:
                          Get.to(() => ReportPage());
                          break;
                        case 4:
                          // Navigate to Settings Screen
                          Get.to(() => const SettingsScreen());
                          break;
                        case 5:
                          showSettingsDialog(context);
                          break;
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                        leading: Icon(
                          icons[i],
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          texts[i],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
