import 'package:get/get.dart';

import '../db/database_helper.dart';
import '../model/category_model.dart';
import '../model/task_model.dart';
import '../utils/app_preferences.dart';
import '../utils/logger.dart';

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
      AppLogger.d('Starting database initialization');
      await DatabaseHelper.instance.database;
      await getTasks();
      await getCategories();
      AppLogger.d('Categories loaded: ${categoryList.length}');

      // Only add default categories if it's the first launch or no categories exist
      await _addDefaultCategoriesIfEmpty();

      // Mark first launch as completed if it's the first time
      final isFirstLaunch = await AppPreferences.isFirstLaunch();
      if (isFirstLaunch) {
        await AppPreferences.setFirstLaunchCompleted();
        AppLogger.d('First app launch completed');
      }

      AppLogger.d(
          'Database initialization completed. Final categories: ${categoryList.length}');
    } catch (e) {
      AppLogger.e('Error initializing database: $e');
    }
  }

  Future<int> addCategory({
    required String name,
    required String icon,
    required String color,
  }) async {
    try {
      // Check if category with the same name already exists
      final existingCategories = await getCategories();
      bool categoryExists = existingCategories
          .any((category) => category.name.toLowerCase() == name.toLowerCase());

      if (categoryExists) {
        AppLogger.w('Category with name "$name" already exists');
        return -1; // Indicate that category already exists
      }

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

      // Refresh categories list after successful insertion
      if (id != -1) {
        await getTasks();
      }

      return id;
    } catch (e) {
      AppLogger.e('Error adding category: $e');
      return -1; // Indicate failure
    }
  }

  // Method to fetch categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      AppLogger.d('Fetching categories from database');
      final categoriesMap = await DatabaseHelper.instance.queryCategories();
      final categories =
          categoriesMap.map((map) => CategoryModel.fromJson(map)).toList();
      categoryList.assignAll(categories); // Update the observable list
      AppLogger.d('Categories fetched: ${categories.length}');
      return categories;
    } catch (e) {
      AppLogger.e('Error fetching categories: $e');
      return [];
    }
  }

  // Method to delete a category
  Future<bool> deleteCategory(int categoryId) async {
    try {
      // Check if there are any tasks associated with this category
      final tasksWithCategory =
          taskList.where((task) => task.categoryId == categoryId).toList();

      if (tasksWithCategory.isNotEmpty) {
        AppLogger.w(
            'Cannot delete category: ${tasksWithCategory.length} tasks are associated with this category');
        return false; // Cannot delete category with associated tasks
      }

      final result = await DatabaseHelper.instance.deleteCategory(categoryId);
      if (result > 0) {
        // Remove from the observable list
        categoryList.removeWhere((category) => category.id == categoryId);
        AppLogger.d('Category deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.e('Error deleting category: $e');
      return false;
    }
  }

  // Task Management Methods
  Future<void> getTasks() async {
    try {
      List<Map<String, dynamic>> tasks = await DatabaseHelper.instance.query();
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    } catch (e) {
      AppLogger.e('Error fetching tasks: $e');
    }
  }

  Future<int> addTask({Task? task}) async {
    try {
      int result = await DatabaseHelper.instance.insertTask(task);
      await getTasks();
      return result;
    } catch (e) {
      AppLogger.e('Error adding task: $e');
      return -1;
    }
  }

  void updateTask({Task? task}) async {
    try {
      await DatabaseHelper.instance.updateTaskDetail(task!);
      await getTasks();
    } catch (e) {
      AppLogger.e('Error updating task: $e');
    }
  }

  Future<void> _addDefaultCategoriesIfEmpty() async {
    try {
      // Check if default categories have already been added using SharedPreferences
      final categoriesAlreadyAdded =
          await AppPreferences.areDefaultCategoriesAdded();
      if (categoriesAlreadyAdded) {
        AppLogger.d('Default categories already added previously');
        return;
      }

      // Double check by looking at database
      final categoriesFromDb = await DatabaseHelper.instance.queryCategories();
      if (categoriesFromDb.isNotEmpty) {
        AppLogger.d('Categories exist in database: ${categoriesFromDb.length}');
        // Mark as added in preferences to avoid future checks
        await AppPreferences.setDefaultCategoriesAdded();
        return;
      }

      AppLogger.d('No categories found in database. Adding default categories');
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
        // Create CategoryModel and insert directly to avoid duplicate checking in addCategory
        final newCategory = CategoryModel(
          id: DateTime.now().millisecondsSinceEpoch +
              defaultCategories.indexOf(category),
          name: category['name']!,
          icon: category['icon']!,
          color: category['color']!,
          remainingTasks: 0,
          completedTasks: 0,
        );
        await DatabaseHelper.instance.insertCategory(newCategory);
      }

      // Mark default categories as added in SharedPreferences
      await AppPreferences.setDefaultCategoriesAdded();

      // Refresh the category list after adding defaults
      await getCategories();
      AppLogger.d(
          'Default categories added successfully. Total: ${categoryList.length}');
    } catch (e) {
      AppLogger.e('Error in _addDefaultCategoriesIfEmpty: $e');
    }
  }

  // Task Statistics Methods
  Future<double> getTotalTask() async {
    try {
      await getTasks();
      return taskList.length.toDouble();
    } catch (e) {
      AppLogger.e('Error getting total tasks: $e');
      return 0.0;
    }
  }

  Future<double> getTotalCompletedTask() async {
    try {
      await getTasks();
      return taskList.where((task) => task.isCompleted == 1).length.toDouble();
    } catch (e) {
      AppLogger.e('Error getting completed tasks: $e');
      return 0.0;
    }
  }

  Future<int> getTotalCompletedProgress() async {
    try {
      double comp = await getTotalCompletedTask();
      double total = await getTotalTask();
      return total > 0 ? ((comp / total) * 100).toInt() : 0;
    } catch (e) {
      AppLogger.e('Error calculating completion progress: $e');
      return 0;
    }
  }

  // Other existing methods (undoTaskCompleted, markTaskCompleted, etc.)
  void undoTaskCompleted(int id) async {
    try {
      await DatabaseHelper.instance.undoCompleted(id);
      await getTasks();
    } catch (e) {
      AppLogger.e('Error undoing task completion: $e');
    }
  }

  void markTaskCompleted(int id) async {
    try {
      await DatabaseHelper.instance.update(id);
      await getTasks();
    } catch (e) {
      AppLogger.e('Error marking task as completed: $e');
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
      AppLogger.e('Error getting tasks by category: $e');
      return [];
    }
  }

  // Method to mark task as starred
  void markTaskStar(int id) async {
    try {
      await DatabaseHelper.instance.markStar(id);
      await getTasks();
    } catch (e) {
      AppLogger.e('Error marking task as starred: $e');
    }
  }

  // Method to undo task star
  void undoTaskStar(int id) async {
    try {
      await DatabaseHelper.instance.undoStar(id);
      await getTasks();
    } catch (e) {
      AppLogger.e('Error unmarking task star: $e');
    }
  }

  void delete(Task task) async {
    try {
      if (task.id != null) {
        await DatabaseHelper.instance.delete(task);
        await getTasks();
      }
    } catch (e) {
      AppLogger.e('Error deleting task: $e');
    }
  }

  // Method to delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await DatabaseHelper.instance.deleteAllTasks();
      await getTasks();
      await getCategories(); // Refresh categories to update task counts
      AppLogger.d('All tasks deleted successfully');
    } catch (e) {
      AppLogger.e('Error deleting all tasks: $e');
      rethrow;
    }
  }

  // Statistics methods for report_page.dart
  Future<double> getOneDayTask() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null && _isSameDay(date, today);
        })
        .length
        .toDouble();
  }

  Future<double> getOneDayCompletedTask() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null &&
              _isSameDay(date, today) &&
              task.isCompleted == 1;
        })
        .length
        .toDouble();
  }

  Future<double> getSevenDaysTasks() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null && isWithinSevenDays(date, today);
        })
        .length
        .toDouble();
  }

  Future<double> getSevenDaysCompletedTasks() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null &&
              isWithinSevenDays(date, today) &&
              task.isCompleted == 1;
        })
        .length
        .toDouble();
  }

  Future<double> getThisMonthTasks() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null && isWithinSameMonth(date, today);
        })
        .length
        .toDouble();
  }

  Future<double> getMonthCompletedTasks() async {
    await getTasks();
    DateTime today = DateTime.now();
    return taskList
        .where((task) {
          final date = _parseDate(task.date);
          return date != null &&
              isWithinSameMonth(date, today) &&
              task.isCompleted == 1;
        })
        .length
        .toDouble();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}
