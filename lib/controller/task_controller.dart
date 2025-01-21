import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../model/task_model.dart';
import '../model/category_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  var categoryList = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await DatabaseHelper.instance.database;
      await getTasks();
      await getCategories();
      await _addDefaultCategoriesIfEmpty();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<int> addCategory({
    required String name,
    required String icon,
    required String color,
  }) async {
    try {
      final newCategory = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        // Temporary ID
        name: name,
        icon: icon,
        color: color,
        remainingTasks: 0,
        completedTasks: 0,
      );

      // Insert the category into the database
      final id = await DatabaseHelper.instance.insertCategory(newCategory);
      return id;
    } catch (e) {
      print('Error adding category: $e');
      return -1; // Indicate failure
    }
  }

  // Method to fetch categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoriesMap = await DatabaseHelper.instance.queryCategories();
      return categoriesMap.map((map) => CategoryModel.fromJson(map)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

// In task_controller.dart
//   Future<int> addCategory({
//     required String name,
//     required String icon,
//     required String color,
//   }) async {
//     try {
//       // Create a new CategoryModel
//       final newCategory = CategoryModel(
//         id: DateTime.now().millisecondsSinceEpoch, // Temporary ID generation
//         name: name,
//         icon: icon,
//         color: color,
//         remainingTasks: 0,
//         completedTasks: 0,
//       );
//
//       // Insert the category into the database
//       final id = await DatabaseHelper.instance.insertCategory(newCategory);
//
//       return id;
//     } catch (e) {
//       print('Error adding category in controller: $e');
//       return -1;
//     }
//   }

  // Future<List<CategoryModel>> getCategories() async {
  //   try {
  //     // Fetch categories from the database
  //     final categoriesMap = await DatabaseHelper.instance.queryCategories();
  //     return categoriesMap.map((map) => CategoryModel.fromJson(map)).toList();
  //   } catch (e) {
  //     print('Error getting categories: $e');
  //     return [];
  //   }
  // }

  // Task Management Methods
  Future<void> getTasks() async {
    try {
      List<Map<String, dynamic>> tasks = await DatabaseHelper.instance.query();
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<int> addTask({Task? task}) async {
    try {
      int result = await DatabaseHelper.instance.insertTask(task);
      await getTasks();
      return result;
    } catch (e) {
      print('Error adding task: $e');
      return -1;
    }
  }

  void updateTask({Task? task}) async {
    try {
      await DatabaseHelper.instance.updateTaskDetail(task!);
      await getTasks();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> _addDefaultCategoriesIfEmpty() async {
    if (categoryList.isEmpty) {
      List<Map<String, dynamic>> defaultCategories = [
        {
          'name': 'Personal',
          'icon': 'person_outline',
          'color': '#FF7B86',
        },
        {
          'name': 'Work',
          'icon': 'work_outline',
          'color': '#4ECDC4',
        },
        {
          'name': 'Important',
          'icon': 'priority_high',
          'color': '#FFB900',
        }
      ];

      for (var category in defaultCategories) {
        await addCategory(
            name: category['name']!,
            icon: category['icon']!,
            color: category['color']!);
      }
    }
  }

  // Task Statistics Methods
  Future<double> getTotalTask() async {
    try {
      await getTasks();
      return taskList.length.toDouble();
    } catch (e) {
      print('Error getting total tasks: $e');
      return 0.0;
    }
  }

  Future<double> getTotalCompletedTask() async {
    try {
      await getTasks();
      return taskList.where((task) => task.isCompleted == 1).length.toDouble();
    } catch (e) {
      print('Error getting completed tasks: $e');
      return 0.0;
    }
  }

  Future<int> getTotalCompletedProgress() async {
    try {
      double comp = await getTotalCompletedTask();
      double total = await getTotalTask();
      return total > 0 ? ((comp / total) * 100).toInt() : 0;
    } catch (e) {
      print('Error calculating completion progress: $e');
      return 0;
    }
  }

  // Other existing methods (undoTaskCompleted, markTaskCompleted, etc.)
  void undoTaskCompleted(int id) async {
    try {
      await DatabaseHelper.instance.undoCompleted(id);
      await getTasks();
    } catch (e) {
      print('Error undoing task completion: $e');
    }
  }

  void markTaskCompleted(int id) async {
    try {
      await DatabaseHelper.instance.update(id);
      await getTasks();
    } catch (e) {
      print('Error marking task as completed: $e');
    }
  }

  // Existing date-related methods
  bool isWithinSameMonth(DateTime taskDate, DateTime today) {
    return taskDate.month == today.month && taskDate.year == today.year;
  }

  bool isWithinSevenDays(DateTime taskDate, DateTime today) {
    Duration difference = today.difference(taskDate);
    return difference.inDays <= 6;
  }

  // Method to get tasks by category
  Future<List<Task>> getTasksByCategory(int categoryId) async {
    try {
      await getTasks();
      return taskList.where((task) => task.categoryId == categoryId).toList();
    } catch (e) {
      getCategories() {}
      ('Error getting tasks by category: $e');
      return [];
    }
  }

  void delete(Task task) {}
}
