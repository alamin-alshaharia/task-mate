import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/modular/modular_widgets.dart';
import 'package:flutter_task_planner_app/widgets/note_widgets/toast.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';

class AddNewNotePage extends StatelessWidget {
  final NoteController controller = Get.find();

  AddNewNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.titleController.text = "";
    controller.contentController.text = "";

    return Scaffold(
      backgroundColor: LightColors.backgroundColor,
      appBar: ModularAppBar(
        title: "Add New Note",
        subtitle: "",
        onBackPressed: () => Get.back(),
        actions: [
          ModularActionButton(
            icon: Icons.save_rounded,
            onPressed: _saveNote,
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ],
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
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Title Input
                _buildTitleInput(),
                const SizedBox(height: 24),

                // Enhanced Content Input
                _buildContentInput(),

                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ModularFloatingButton(
        label: "Save Note",
        icon: Icons.save_rounded,
        onPressed: _saveNote,
        gradient: LightColors.primaryGradient,
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LightColors.primaryBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: LightColors.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: controller.titleController,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: LightColors.textPrimary,
            letterSpacing: -0.5,
          ),
          cursorColor: LightColors.primaryBlue,
          decoration: InputDecoration(
            hintText: "Note Title",
            hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LightColors.textHint,
              letterSpacing: -0.5,
            ),
            border: InputBorder.none,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.title_rounded,
                color: LightColors.primaryBlue.withOpacity(0.6),
                size: 28,
              ),
            ),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LightColors.primaryBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: LightColors.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: controller.contentController,
          style: const TextStyle(
            fontSize: 18,
            color: LightColors.textPrimary,
            height: 1.6,
            letterSpacing: 0.2,
          ),
          cursorColor: LightColors.primaryBlue,
          decoration: InputDecoration(
            hintText: "Start writing your note here...",
            hintStyle: TextStyle(
              fontSize: 18,
              color: LightColors.textHint,
              height: 1.6,
            ),
            border: InputBorder.none,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 16, bottom: 260),
              child: Icon(
                Icons.edit_note_rounded,
                color: LightColors.primaryBlue.withOpacity(0.6),
                size: 24,
              ),
            ),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 12,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }

  void _saveNote() {
    if (controller.titleController.text.trim().isEmpty) {
      showToast(message: "Please enter a note title");
    } else if (controller.contentController.text.trim().isEmpty) {
      showToast(message: "Please enter note content");
    } else {
      controller.addNoteToDatabase();
    }
  }
}
