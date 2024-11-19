import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/screens/note_screens/note_detail_page.dart';
import 'package:flutter_task_planner_app/screens/note_screens/search_screen.dart';
import 'package:flutter_task_planner_app/widgets/note_widgets/alert_dialog.dart';

import 'package:get/get.dart';

import '../../theme/colors/colors.dart';
import '../../controller/note_controller.dart';

import 'add_new_note_page.dart';

class Homenote extends StatelessWidget {
  final controller = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kLightYellow,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Note",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColor.kLightYellow2,
        iconTheme: const IconThemeData(
          color: Colors.black45,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          ),
          PopupMenuButton(
            onSelected: (val) {
              if (val == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWidget(
                      headingText: "Are you sure you want to delete all notes?",
                      contentText:
                          "This will delete all notes permanently. You cannot undo this action.",
                      confirmFunction: () {
                        controller.deleteAllNotes();
                        Get.back();
                      },
                      declineFunction: () {
                        Get.back();
                      },
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(
                  "Delete All Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: GetBuilder<NoteController>(
        builder: (_) => controller.isEmpty() ? emptyNotes() : viewNotes(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(AddNewNotePage());
        },
        label: const Text(
          "Add new note",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
        ),
        backgroundColor: AppColor.kDarkYellow,
      ),
    );
  }

  Widget viewNotes() {
    return Scrollbar(
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: controller.notes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(NoteDetailPage(), arguments: index);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWidget(
                      headingText: "Are you sure you want to delete this note?",
                      contentText:
                          "This will delete the note permanently. You cannot undo this action.",
                      confirmFunction: () {
                        controller.deleteNote(controller.notes[index].id!);
                        Get.back();
                      },
                      declineFunction: () {
                        Get.back();
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.notes[index].id == 1
                        ? AppColor.kDarkYellow
                        : controller.notes[index].id == 2
                            ? AppColor.kPalePink
                            : controller.notes[index].id == 3
                                ? Colors.redAccent
                                : (controller.notes[index].id)! % 2 == 0
                                    ? AppColor.kDarkYellow
                                    : AppColor.kPalePink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.notes[index].title!,
                              style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.textColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              controller.notes[index].content!,
                              style: const TextStyle(
                                  fontSize: 18, color: AppColor.textColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              controller.notes[index].dateTimeEdited!,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColor.textColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          controller.favoriteNote(controller.notes[index].id!);
                        },
                        child: Icon(
                          controller.notes[index].isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget emptyNotes() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            height: 200,
            width: 200,
            image: AssetImage('./assets/images/no_notes.png'),
          ),
          Text(
            "Create your first note!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
