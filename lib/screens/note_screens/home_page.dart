import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/note_screens/search_screen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/common/delete_confirmation_dialog.dart';
import 'package:flutter_task_planner_app/widgets/modular/modular_note_card.dart';
import 'package:flutter_task_planner_app/widgets/modular/modular_widgets.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';
import 'add_new_note_page.dart';

class Homenote extends StatelessWidget {
  final controller = Get.put(NoteController());

  Homenote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.backgroundColor,
      appBar: ModularAppBar(
        title: "My Notes",
        subtitle: "",
        actions: [
          ModularActionButton(
            icon: Icons.search_rounded,
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: PopupMenuButton(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (val) {
                if (val == 0) {
                  DeleteConfirmationDialog.showDeleteAllNotesDialog(
                    context: context,
                    onConfirm: () {
                      controller.deleteAllNotes();
                      Get.back();
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text(
                        "Delete All Notes",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GetBuilder<NoteController>(
        builder: (_) => controller.isEmpty() ? emptyNotes() : viewNotes(),
      ),
      floatingActionButton: ModularFloatingButton(
        label: 'New Note',
        icon: Icons.add_rounded,
        onPressed: () {
          Get.to(AddNewNotePage());
        },
        gradient: LightColors.primaryGradient,
      ),
    );
  }

  Widget viewNotes() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.notes.length,
        itemBuilder: (context, index) {
          final note = controller.notes[index];
          return ModularNoteCard(
            note: note,
            index: index,
            controller: controller,
          );
        },
      ),
    );
  }

  Widget emptyNotes() {
    return ModularEmptyState(
      icon: Icons.note_add_outlined,
      title: "No notes yet",
      subtitle: "Start your journey by creating\nyour first note",
      buttonText: "Create First Note",
      onButtonPressed: () {
        Get.to(AddNewNotePage());
      },
      iconGradient: LightColors.primaryGradient,
    );
  }
}
