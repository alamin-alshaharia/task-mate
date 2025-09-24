import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/modular/modular_widgets.dart';
import 'package:get/get.dart';

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
      backgroundColor: LightColors.backgroundColor,
      appBar: ModularAppBar(
        title: "Edit Note",
        subtitle: "Modify your note content",
        onBackPressed: () => Get.back(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              LightColors.backgroundColor,
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Title Input Container
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LightColors.blueGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: LightColors.primaryBlue.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: TextField(
                      controller: controller.titleController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LightColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                      cursorColor: LightColors.primaryBlue,
                      decoration: InputDecoration(
                        hintText: "Enter note title...",
                        hintStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: LightColors.textHint,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.title_rounded,
                          color: LightColors.primaryBlue.withOpacity(0.7),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content Input Container
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LightColors.greenGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: LightColors.kGreen.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: controller.contentController,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: LightColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                      cursorColor: LightColors.kGreen,
                      decoration: InputDecoration(
                        hintText: "Start writing your note content here...",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: LightColors.textHint,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Icon(
                            Icons.edit_note_rounded,
                            color: LightColors.kGreen.withOpacity(0.7),
                            size: 24,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 0,
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                    ),
                  ),
                ),

                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ModularFloatingButton(
        onPressed: () {
          if (controller.titleController.text.trim().isEmpty) {
            Get.snackbar(
              'Warning',
              'Please enter a title for your note',
              backgroundColor: LightColors.redGradient.colors.first,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          controller.updateNote(
            controller.notes[noteIndex].id!,
            controller.notes[noteIndex].dateTimeCreated!,
          );

          Get.snackbar(
            'Success',
            'Note updated successfully!',
            backgroundColor: LightColors.greenGradient.colors.first,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.back();
        },
        label: "Update Note",
        icon: Icons.save_rounded,
        gradient: LightColors.primaryGradient,
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
