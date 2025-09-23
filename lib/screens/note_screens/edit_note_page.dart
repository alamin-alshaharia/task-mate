// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';
// // import 'package:flutter_task_planner_app/theme/colors/colors.dart';
// //
// // import '../../controller/note_controller.dart';
// //
// // class EditNotePage extends StatelessWidget {
// //   final NoteController controller = Get.find();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final int i = ModalRoute.of(context)?.settings.arguments as int;
// //     controller.titleController.text = controller.notes[i].title!;
// //     controller.contentController.text = controller.notes[i].content!;
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         iconTheme: const IconThemeData(
// //           color: Colors.black,
// //         ),
// //         title: const Text(
// //           "Edit Note",
// //           style: TextStyle(
// //             color: Colors.black,
// //           ),
// //         ),
// //         systemOverlayStyle: SystemUiOverlayStyle.dark,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Container(
// //           padding: const EdgeInsets.only(
// //             top: 15,
// //             left: 15,
// //             right: 15,
// //           ),
// //           child: Column(
// //             children: [
// //               TextField(
// //                 controller: controller.titleController,
// //                 style: const TextStyle(
// //                   fontSize: 27,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //                 cursorColor: Colors.black,
// //                 enableInteractiveSelection: false,
// //                 decoration: InputDecoration(
// //                   hintText: "Title",
// //                   hintStyle: TextStyle(
// //                     fontSize: 27,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.grey[600],
// //                     letterSpacing: 1,
// //                   ),
// //                   border: InputBorder.none,
// //                 ),
// //               ),
// //               TextField(
// //                 style: const TextStyle(
// //                   fontSize: 22,
// //                 ),
// //                 cursorColor: Colors.black,
// //                 enableInteractiveSelection: false,
// //                 controller: controller.contentController,
// //                 decoration: const InputDecoration(
// //                   hintText: "Content",
// //                   hintStyle: TextStyle(
// //                     fontSize: 17,
// //                   ),
// //                   border: InputBorder.none,
// //                 ),
// //                 keyboardType: TextInputType.multiline,
// //                 maxLines: null,
// //                 autofocus: true,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () {
// //           controller.updateNote(
// //               controller.notes[i].id!, controller.notes[i].dateTimeCreated!);
// //         },
// //         label: const Text(
// //           "Save Note",
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //               fontSize: 16,
// //               fontFamily: 'Poppins',
// //               fontWeight: FontWeight.w500,
// //               color: Colors.white),
// //         ),
// //         icon: const Icon(
// //           Icons.save,
// //         ),
// //         backgroundColor: AppColor.buttonColor,
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:flutter_task_planner_app/theme/colors/colors.dart';
// import '../../controller/note_controller.dart';
//
// class EditNotePage extends StatelessWidget {
//   final NoteController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the arguments safely
//     final arguments = ModalRoute.of(context)?.settings.arguments;
//
//     // Check if arguments are provided and are of the expected type
//     if (arguments is int) {
//       final int i = arguments;
//
//       // Ensure the index is within bounds
//       if (i < 0 || i >= controller.notes.length) {
//         // Handle the error (e.g., show a message or navigate back)
//         return Scaffold(
//           body: Center(
//             child: Text('Invalid note index.'),
//           ),
//         );
//       }
//
//       // Initialize the text controllers with note data
//       controller.titleController.text = controller.notes[i].title ?? '';
//       controller.contentController.text = controller.notes[i].content ?? '';
//
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: const IconThemeData(
//             color: Colors.black,
//           ),
//           title: const Text(
//             "Edit Note",
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//           systemOverlayStyle: SystemUiOverlayStyle.dark,
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.only(
//               top: 15,
//               left: 15,
//               right: 15,
//             ),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: controller.titleController,
//                   style: const TextStyle(
//                     fontSize: 27,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   cursorColor: Colors.black,
//                   enableInteractiveSelection: false,
//                   decoration: InputDecoration(
//                     hintText: "Title",
//                     hintStyle: TextStyle(
//                       fontSize: 27,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                       letterSpacing: 1,
//                     ),
//                     border: InputBorder.none,
//                   ),
//                 ),
//                 TextField(
//                   style: const TextStyle(
//                     fontSize: 22,
//                   ),
//                   cursorColor: Colors.black,
//                   enableInteractiveSelection: false,
//                   controller: controller.contentController,
//                   decoration: const InputDecoration(
//                     hintText: "Content",
//                     hintStyle: TextStyle(
//                       fontSize: 17,
//                     ),
//                     border: InputBorder.none,
//                   ),
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   autofocus: true,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             controller.updateNote(
//                 controller.notes[i].id!, controller.notes[i].dateTimeCreated!);
//           },
//           label: const Text(
//             "Save Note",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontSize: 16,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white),
//           ),
//           icon: const Icon(
//             Icons.save,
//           ),
//           backgroundColor: AppColor.buttonColor,
//         ),
//       );
//     } else {
//       // Handle the case where arguments are not an int
//       return Scaffold(
//         body: Center(
//           child: Text('No note index provided.'),
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_task_planner_app/theme/colors/colors.dart';
import '../../controller/note_controller.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({super.key});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final NoteController controller = Get.find();
  late int noteIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the arguments safely
    final arguments = ModalRoute.of(context)?.settings.arguments;

    // Check if arguments are provided and are of the expected type
    if (arguments is int) {
      noteIndex = arguments;

      // Ensure the index is within bounds
      if (noteIndex < 0 || noteIndex >= controller.notes.length) {
        // Handle the error (e.g., show a message or navigate back)
        Get.snackbar('Error', 'Invalid note index.');
        Get.back();
      } else {
        // Initialize the text controllers with note data
        controller.titleController.text =
            controller.notes[noteIndex].title ?? '';
        controller.contentController.text =
            controller.notes[noteIndex].content ?? '';
      }
    } else {
      // Handle the case where arguments are not an int
      Get.snackbar('Error', 'No note index provided.');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Edit Note",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              TextField(
                controller: controller.titleController,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1,
                  ),
                  border: InputBorder.none,
                ),
              ),
              TextField(
                style: const TextStyle(
                  fontSize: 22,
                ),
                cursorColor: Colors.black,
                enableInteractiveSelection: false,
                controller: controller.contentController,
                decoration: const InputDecoration(
                  hintText: "Content",
                  hintStyle: TextStyle(
                    fontSize: 17,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.updateNote(controller.notes[noteIndex].id!,
              controller.notes[noteIndex].dateTimeCreated!);
          Get.back(); // Optionally navigate back after saving
        },
        label: const Text(
          "Save Note",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        icon: const Icon(
          Icons.save,
        ),
        backgroundColor: AppColor.buttonColor,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers if they are not needed anymore
    controller.titleController.clear();
    controller.contentController.clear();
    super.dispose();
  }
}
