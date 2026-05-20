import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/screens/note_screens/edit_note_page.dart';
import 'package:flutter_task_planner_app/screens/note_screens/home_page.dart';
import 'package:flutter_task_planner_app/widgets/common/delete_confirmation_dialog.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteController controller = Get.find();

  NoteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments safely
    final arguments = ModalRoute.of(context)?.settings.arguments;

    // Check if arguments are provided and are of the expected type
    if (arguments is int) {
      final int i = arguments;

      return GetBuilder<NoteController>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Note Details",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              // Favorite button
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.notes[i].isFavorite == true
                          ? Colors.red.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      controller.notes[i].isFavorite == true
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: controller.notes[i].isFavorite == true
                          ? Colors.red.shade600
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    controller.favoriteNote(controller.notes[i].id!);
                  },
                ),
              ),

              // Menu button
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: PopupMenuButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (val) {
                    if (val == 0) {
                      editNote(i);
                    } else if (val == 1) {
                      deleteNote(context, i);
                    } else if (val == 2) {
                      shareNote(i);
                    }
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      const PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 18, color: Colors.blue),
                            SizedBox(width: 12),
                            Text(
                              "Edit Note",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 12),
                            Text(
                              "Delete Note",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.share_outlined,
                                size: 18, color: Colors.green),
                            SizedBox(width: 12),
                            Text(
                              "Share Note",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: Container(
            color: Colors.grey.shade50,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),

                // Note content card
                SliverToBoxAdapter(
                  child: Hero(
                    tag: 'note_${controller.notes[i].id}',
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section with gradient
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade50,
                                  Colors.purple.shade50,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                SelectableText(
                                  controller.notes[i].title!,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    height: 1.2,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Metadata row
                                Row(
                                  children: [
                                    // Last edited badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.schedule_rounded,
                                            size: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.notes[i].dateTimeEdited!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Word count badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.text_fields_rounded,
                                            size: 14,
                                            color: Colors.green.shade700,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${controller.notes[i].content!.split(' ').length} words',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Reading time estimate
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 14,
                                        color: Colors.orange.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${(controller.notes[i].content!.split(' ').length / 200).ceil()} min read',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content section
                          Container(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Content
                                SelectableText(
                                  controller.notes[i].content!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    height: 1.7,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),

          // Floating Action Buttons
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Edit button
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: FloatingActionButton(
                  heroTag: "edit",
                  onPressed: () => editNote(i),
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  child: const Icon(Icons.edit_rounded, size: 24),
                ),
              ),

              // Share button
              FloatingActionButton(
                heroTag: "share",
                onPressed: () => shareNote(i),
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                elevation: 8,
                child: const Icon(Icons.share_rounded, size: 24),
              ),
            ],
          ),
        ),
      );
    } else {
      // Handle the case where arguments are not an int
      return Scaffold(
        body: Center(
          child: Text('No note index provided.'),
        ),
      );
    }
  }

  void editNote(int i) async {
    Get.to(() => EditNotePage(),
        arguments: i); // Pass the index to EditNotePage
  }

  void deleteNote(BuildContext context, int i) async {
    await DeleteConfirmationDialog.showNoteDeleteDialog(
      context: context,
      noteTitle: controller.notes[i].title ?? '',
      onConfirm: () {
        controller.deleteNote(controller.notes[i].id!);
        Get.to(Homenote());
      },
    );
  }

  void shareNote(int i) async {
    controller.shareNote(
      controller.notes[i].title!,
      controller.notes[i].content!,
    );
  }
}
