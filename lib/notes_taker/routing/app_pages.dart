// ignore_for_file: prefer_const_constructors

import 'package:get/route_manager.dart';
import 'package:flutter_task_planner_app/notes_taker/screens/add_new_note_page.dart';
import 'package:flutter_task_planner_app/notes_taker/screens/edit_note_page.dart';
import 'package:flutter_task_planner_app/notes_taker/screens/note_detail_page.dart';

import 'app_routes.dart';

var getRoutes = [
  //GetPage(name: AppRoute.SPLASH, page: () => Login()),
  // GetPage(name: AppRoute.HOME, page: () => HomePage()),
  GetPage(name: AppRoute.ADD_NEW_NOTE, page: () => AddNewNotePage()),
  GetPage(name: AppRoute.EDIT_NOTE, page: () => EditNotePage()),
  GetPage(name: AppRoute.NOTE_DETAILS, page: () => NoteDetailPage()),
];
