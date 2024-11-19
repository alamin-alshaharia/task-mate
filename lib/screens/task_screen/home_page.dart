import 'dart:io';
import 'package:flutter_task_planner_app/screens/note_screens/home_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/profile.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:flutter_task_planner_app/screens/task_screen/all_task_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/calendar_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/report_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/search_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:get/get.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_column.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/active_project_card.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/top_container.dart';

import '../../Controller/task_controller.dart';
import '../../controller/profile_controller.dart';

import '../../latest_calender_screen.dart';
import 'create_new_task_page.dart';

class HomePage extends StatefulWidget {
  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();
  int? completedTaskCount;
  final TaskController _taskController = Get.put(TaskController());
  int totalTask = 0;
  int completedTask = 0;
  double totalProgress = .75;
  Future<void> _fetchAllTaskStats() async {
    try {
      double totalResult = await _taskController.getTotalTask();
      double completedResult = await _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
        _taskController.getTasks();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllTaskStats();
    // _taskController.getTasks();
    _taskController.getTasks();
    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController _profileController = Get.put(ProfileController());
    var todoTasks = totalTask - completedTask;
    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
    // DatabaseHelper.listenForChanges(_taskController.updateCount);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: todoTasks != 0
          ? FloatingActionButton(
              onPressed: () => Get.to(CreateNewTaskPage()),
              child: Icon(Icons.add), // You can change the icon as needed
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SliderDrawer(
        // isDraggable: false,
        key: dKey,
        animationDuration: 200,
        slider: MySlider(),
        appBar: SliderAppBar(
          appBarPadding: EdgeInsets.fromLTRB(20, 35, 22, 0),
          appBarColor: LightColors.kDarkYellow,
          title: Container(),
          trailing: IconButton(
            icon: Icon(Icons.search),
            iconSize: 31,
            onPressed: () {
              Get.to(SearchPage());
            },
          ),
        ),
        child: Container(
          color: LightColors.kLightYellow,
          child: Column(
            children: <Widget>[
              TopContainer(
                height: 190,
                width: width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Obx(() {
                              final profile = _profileController.profile.value;
                              return CircularPercentIndicator(
                                radius: 65.0,
                                lineWidth: 7.0,
                                animation: true,
                                percent: .75,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: LightColors.kRed,
                                backgroundColor: LightColors.kDarkYellow,
                                center: CircleAvatar(
                                  backgroundColor: LightColors.kBlue,
                                  radius: 40.0,
                                  backgroundImage: profile.imageData != null
                                      ? MemoryImage(profile.imageData!)
                                      : const AssetImage(
                                              'assets/images/avatar.png')
                                          as ImageProvider,
                                ),
                              );
                            }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: const Text(
                                    'Welcome',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: LightColors.kDarkBlue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Obx(() {
                                  final profile =
                                      _profileController.profile.value;
                                  return Container(
                                    child: Text(
                                      profile.name ?? "User Name",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomepageButton(
                      buttonTitle: "Task Report",
                      onpress: () => ReportPage(),
                    ),
                    HomepageButton(
                      buttonTitle: "Note  Manager",
                      onpress: () => Homenote(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('My Tasks'),
                            GestureDetector(
                              onTap: () async {
                                Get.to(CalendarTimelinePage());
                                _taskController.getTasks();
                              },
                              child: HomePage.calendarIcon(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        GestureDetector(
                          onTap: () => Get.to(AllTaskPage(
                            indexs: 0,
                          )),
                          child: TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'To Do',
                            subtitle: '${todoTasks}tasks now. ',
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        GestureDetector(
                          onTap: () => Get.to(AllTaskPage(
                            indexs: 2,
                          )),
                          child: TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'Total Task',
                            subtitle: '${totalTask} tasks now. ',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        GestureDetector(
                          onTap: () => Get.to(AllTaskPage(
                            indexs: 1,
                          )),
                          child: TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Done',
                            subtitle: '${completedTask} tasks now. ',
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: subheading('Active Projects'),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              todoTasks == 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 7),
                      child: Row(children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(15.0),
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            gradient: LightColors.brownGradient,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: CircularPercentIndicator(
                              animation: true,
                              radius: 50.0,
                              percent: 1.0,
                              lineWidth: 5.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: Colors.white10,
                              progressColor: LightColors.kLightBlue,
                              center: IconButton(
                                  onPressed: () => Get.to(CreateNewTaskPage()),
                                  icon: Icon(
                                    Icons.add,
                                    size: 50,
                                  ))),
                        ),
                      ]),
                    )
                  : _showActiveProject()
            ],
          ),
        ),
      ),
    );
  }

  Widget _showActiveProject() {
    return Obx(() {
      // 1. Filter the task list inside the Obx
      final activeTasks = _taskController.taskList
          .where((task) => task.isCompleted == 0)
          .toList();

      return Expanded(
        child: GridView.builder(
          // 2. Use the filtered list length
          itemCount: activeTasks.length,
          itemBuilder: (context, index) {
            // 3. Access tasks directly from the filtered list
            var task = activeTasks[index];

            return AnimationConfiguration.staggeredGrid(
              columnCount: 2,
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ActiveProjectsCard(
                      task: task,
                    ),
                  ),
                ),
              ),
            );
          },
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.all(10),
        ),
      );
    });
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

class HomepageButton extends StatelessWidget {
  const HomepageButton(
      {super.key, required this.buttonTitle, required this.onpress});
  final String buttonTitle;
  final Function() onpress;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 43,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: () => Get.to(onpress),
          child: Text(buttonTitle)),
    );
  }
}

// drwar widget
class MySlider extends StatelessWidget {
  MySlider({
    Key? key,
  }) : super(key: key);
  final ProfileController _profileController = Get.put(ProfileController());

  /// Icons
  List<IconData> icons = [
    // CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.doc_richtext,
    CupertinoIcons.calendar_circle_fill,
    CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  List<String> texts = [
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
                          _showSettingsDialog(context);
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
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 90),
  //     decoration: const BoxDecoration(gradient: LightColors.brownGradient),
  //     child: Column(
  //       children: [
  //         const CircleAvatar(
  //           radius: 50,
  //           backgroundImage: AssetImage('assets/images/avatar.png'),
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Text(
  //           "Shaharia",
  //         ),
  //         Text(
  //           "junior flutter dev",
  //         ),
  //         Container(
  //           margin: const EdgeInsets.symmetric(
  //             vertical: 30,
  //             horizontal: 10,
  //           ),
  //           width: double.infinity,
  //           height: 400,
  //           child: ListView.builder(
  //               itemCount: icons.length,
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemBuilder: (ctx, i) {
  //                 return InkWell(
  //                   // ignore: avoid_print
  //                   onTap: () {
  //                     if (i == 3) {
  //                       Get.to(ReportPage());
  //                     }
  //                     if (i == 2) {
  //                       Get.to(CalendarPage());
  //                     }
  //                     if (i == 1) {
  //                       Get.to(AllTaskPage());
  //                     }
  //                     if (i == 4) {}
  //                   },
  //                   child: Container(
  //                     margin: const EdgeInsets.all(5),
  //                     child: ListTile(
  //                         leading: Icon(
  //                           icons[i],
  //                           color: Colors.white,
  //                           size: 30,
  //                         ),
  //                         title: Text(
  //                           texts[i],
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                         )),
  //                   ),
  //                 );
  //               }),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingsDialog();
    },
  );
}

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _isDarkTheme = false;
  bool _isBackupEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('Switch Theme'),
            value: _isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                NotifyHelper()
                    .displayNotification(title: "Theme", body: 'Theme Changed');
                _isDarkTheme = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Firebase Backup'),
            value: _isBackupEnabled,
            onChanged: (bool value) {
              setState(() {
                value
                    ? NotifyHelper().displayNotification(
                        title: "Firebase Backup", body: 'Backup is  Enable')
                    : NotifyHelper().displayNotification(
                        title: "Firebase Backup", body: 'Backup is disable');
                _isBackupEnabled = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

// class MySlider extends StatefulWidget {
//   const MySlider({Key? key}) : super(key: key);
//
//   @override
//   State<MySlider> createState() => _MySliderState();
// }
//
// class _MySliderState extends State<MySlider> {
//   /// Icons
//
//   List<IconData> icons = [
//     CupertinoIcons.person_fill,
//     CupertinoIcons.doc_richtext,
//     CupertinoIcons.calendar_circle_fill,
//     CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
//     CupertinoIcons.settings,
//     CupertinoIcons.info_circle_fill,
//   ];
//
//   /// Texts
//   List<String> texts = [
//     "Profile",
//     "All Task",
//     "Task Calender",
//     "Task Report",
//     "Settings",
//     "Details",
//   ];
//
//   // User data
//   String? _userName;
//   String? _userProfession;
//   String? _userImageUrl;
//   File? _cachedProfileImage; // Store cached profile image
//
//   // Firebase instance
//   final _auth = FirebaseAuth.instance;
//   final _storage = FirebaseStorage.instance;
//
//   // Image picker
//   final ImagePicker _picker = ImagePicker();
//
//   // Function to pick image from gallery
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       // Upload image to Firebase storage
//       final ref = _storage.ref().child('user_images/${_auth.currentUser!.uid}');
//       try {
//         final uploadTask =
//             ref.putFile(File(image.path)); // Correct way to put File
//         final downloadUrl = await (await uploadTask).ref.getDownloadURL();
//
//         // Update user data
//         await _updateUserData(imageUrl: downloadUrl);
//
//         // Cache the image locally
//         _cacheImage(downloadUrl);
//       } catch (e) {
//         print("Error uploading image: $e");
//         // Show an error message to the user
//       }
//     }
//   }
//
// // Function to cache the image locally
//   Future<void> _cacheImage(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         final bytes = response.bodyBytes; // Get the image bytes directly
//         final tempDir = await getTemporaryDirectory();
//         final file = File('${tempDir.path}/profile_image.png');
//         await file.writeAsBytes(bytes);
//         setState(() {
//           _cachedProfileImage = file;
//         });
//       } else {
//         print('Error downloading image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error caching image: $e");
//     }
//   }
//   // Future<void> _cacheImage(String imageUrl) async {
//   //   try {
//   //     final bytes = await NetworkImage(imageUrl).bytes;
//   //     final tempDir = await getTemporaryDirectory();
//   //     final file = File('${tempDir.path}/profile_image.png');
//   //     await file.writeAsBytes(bytes);
//   //     setState(() {
//   //       _cachedProfileImage = file;
//   //     });
//   //   } catch (e) {
//   //     print("Error caching image: $e");
//   //   }
//   // }
//
//   // Function to update user data on Firebase
//   Future<void> _updateUserData(
//       {String? userName, String? userProfession, String? imageUrl}) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       await user.updateProfile(displayName: userName, photoURL: imageUrl);
//       setState(() {
//         _userName = userName;
//         _userProfession = userProfession;
//         _userImageUrl = imageUrl;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }
//
//   // Function to fetch user data from Firebase
//   Future<void> _fetchUserData() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         _userName = user.displayName;
//         _userProfession = user.displayName;
//         _userImageUrl = user.photoURL;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 90),
//       decoration: const BoxDecoration(gradient: LightColors.brownGradient),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               // Show image picker dialog
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('Update Profile Image'),
//                     content: const Text('Choose an image from your gallery.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           _pickImage();
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Pick Image'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             child: CircleAvatar(
//               radius: 50,
//               backgroundImage: _cachedProfileImage != null
//                   ? FileImage(_cachedProfileImage!) // Use cached image
//                   : _userImageUrl != null
//                       ? NetworkImage(_userImageUrl!) as ImageProvider
//                       : const AssetImage('assets/default_profile.png')
//                           as ImageProvider,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             _userName ?? 'User  Name',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             _userProfession ?? 'User  Profession',
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 30),
//           Expanded(
//             child: ListView.builder(
//               itemCount: icons.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Icon(icons[index]),
//                   title: Text(texts[index]),
//                   onTap: () {
//                     // Navigate to corresponding pages
//                     switch (index) {
//                       case 0:
//                         // Get.to(ProfilePage());
//                         break;
//                       case 1:
//                         Get.to(AllTaskPage());
//                         break;
//                       case 2:
//                         Get.to(CalendarPage());
//                         break;
//                       case 3:
//                         Get.to(ReportPage());
//                         break;
//                       case 4:
//                         // Get.to(SettingsPage());
//                         break;
//                       case 5:
//                         // Get.to(DetailsPage());
//                         break;
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
