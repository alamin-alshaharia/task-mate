// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
//
// import '../Controller/task_controller.dart';
// import '../model/task_model.dart';
// import '../widgets/active_project_card.dart';
//
// class active extends StatefulWidget {
//   const active({super.key});
//
//   @override
//   State<active> createState() => _activeState();
// }
//
// class _activeState extends State<active> {
//   final TaskController _taskController = Get.put(TaskController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _showAvtiveProject());
//   }
//
//   _showAvtiveProject() {
//     return Expanded(
//       child: Obx(
//         () {
//           return ListView.builder(
//               itemCount: _taskController.taskList.length,
//               itemBuilder: (_, index) {
//                 Task task = _taskController.taskList[index];
//                 if (task != null) {
//                   return AnimationConfiguration.staggeredList(
//                       position: index,
//                       child: SlideAnimation(
//                         child: FadeInAnimation(
//                           child: Row(
//                             children: [
//                               ActiveProjectsCard(
//                                 task: task,
//                               )
//                             ],
//                           ),
//                         ),
//                       ));
//                 } else {
//                   return Container(); // cannot find any match date
//                 }
//                 return AnimationConfiguration.staggeredList(
//                     position: index,
//                     child: SlideAnimation(
//                       child: FadeInAnimation(
//                         child: Row(
//                           children: [
//                             ActiveProjectsCard(
//                               title: task.title,
//                               subtitle: task.description,
//                             )
//                           ],
//                         ),
//                       ),
//                     ));
//               });
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../Controller/task_controller.dart';
import '../../model/task_model.dart';

import '../../widgets/task_widget/home_page/active_project_card.dart'; // Update with your actual import

class Active extends StatefulWidget {
  const Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    setState(() {
      _taskController.getTasks();
      print("Initialize");
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Projects'), // Add a title to the AppBar if needed
      ),
      body: _showActiveProject(),
    );
  }

  Widget _showActiveProject() {
    return Obx(() {
      return GridView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (context, index) {
          Task task = _taskController.taskList[index];
          if (task.isCompleted == 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ActiveProjectsCard(
                task: task,
              ),
            );
          }
        },
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.all(10),
      );
    });
  }
}
