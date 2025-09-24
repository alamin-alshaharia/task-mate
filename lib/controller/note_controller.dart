import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/model/note_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../db/note_database_helper.dart';

class NoteController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  var notes = <Note>[].obs;

  @override
  void onInit() {
    getAllNotes();
    super.onInit();
  }

  bool isEmpty() {
    return notes.isEmpty;
  }

  void addNoteToDatabase() async {
    String title = titleController.text;
    String content = contentController.text;
    Note note = Note(
        title: title,
        content: content,
        dateTimeEdited: DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now()),
        dateTimeCreated:
            DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now()),
        isFavorite: false);
    await DatabaseHelper.instance.addNote(note);
    titleController.text = "";
    contentController.text = "";
    getAllNotes();
    Get.back();
  }

  void updateNote(int id, String dTCreated) async {
    final title = titleController.text;
    final content = contentController.text;
    Note note = Note(
      id: id,
      title: title,
      content: content,
      dateTimeEdited: DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now()),
      dateTimeCreated: dTCreated,
    );
    await DatabaseHelper.instance.updateNote(note);
    titleController.text = "";
    contentController.text = "";
    getAllNotes();
    // Just go back instead of navigating to a specific page
    Get.back();
  }

  void deleteNote(int id) async {
    Note note = Note(
      id: id,
    );
    await DatabaseHelper.instance.deleteNote(note);
    getAllNotes();
  }

  void favoriteNote(int id) async {
    try {
      Note note = notes.firstWhere((note) => note.id == id);
      if (note.isFavorite == true) {
        note.isFavorite = false; // Mark as not favorite
      } else {
        note.isFavorite = true; // Mark as favorite
      }
      await DatabaseHelper.instance.updateNote(note);

      // Update the specific note in the list
      int index = notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        notes[index] = note;
      }

      // Trigger UI update for this specific favorite button
      update(['favorite_$id']);

      // Also trigger general update for the notes list
      update();
    } catch (e) {
      // Handle error silently or use proper logging
      // debugPrint('Error updating favorite status: $e');
    }
  }

  void deleteAllNotes() async {
    await DatabaseHelper.instance.deleteAllNotes();
    getAllNotes();
  }

  void getAllNotes() async {
    notes.value = await DatabaseHelper.instance.getNoteList();
    update();
  }

  void shareNote(String title, String content) {
    Share.share("$title \n$content");
  }
}
