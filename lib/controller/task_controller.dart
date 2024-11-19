import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../model/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      // Ensure the database is initialized
      await DatabaseHelper.instance.database; // Access the singleton instance
      await getTasks();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

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

  void undoTaskCompleted(int id) async {
    try {
      await DatabaseHelper.instance.undoCompleted(id);
      await getTasks();
    } catch (e) {
      print('Error undoing task completion: $e');
    }
  }

  void undoTaskStar(int id) async {
    try {
      await DatabaseHelper.instance.undoStar(id);
      await getTasks();
    } catch (e) {
      print('Error undoing task star: $e');
    }
  }

  void delete(Task task) async {
    try {
      await DatabaseHelper.instance.delete(task);
      await getTasks();
    } catch (e) {
      print('Error deleting task: $e');
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

  void markTaskStar(int id) async {
    try {
      await DatabaseHelper.instance.markStar(id);
      await getTasks();
    } catch (e) {
      print('Error marking task as star: $e');
    }
  }

  Future<double> getOneDayTask() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) => task.date == DateFormat.yMd().format(today))
          .length
          .toDouble();
    } catch (e) {
      print('Error getting one-day tasks: $e');
      return 0.0;
    }
  }

  Future<double> getOneDayCompletedTask() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) =>
              task.date == DateFormat.yMd().format(today) &&
              task.isCompleted == 1)
          .length
          .toDouble();
    } catch (e) {
      print('Error getting one-day completed tasks: $e');
      return 0.0;
    }
  }

  Future<double> getSevenDaysTasks() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) =>
              isWithinSevenDays(DateFormat.yMd().parse(task.date!), today) &&
              isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
          .length
          .toDouble();
    } catch (e) {
      print('Error getting seven-day tasks: $e');
      return 0.0;
    }
  }

  Future<double> getSevenDaysCompletedTasks() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) =>
              task.isCompleted == 1 &&
              isWithinSevenDays(DateFormat.yMd().parse(task.date!), today) &&
              isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
          .length
          .toDouble();
    } catch (e) {
      print('Error getting seven-day completed tasks: $e');
      return 0.0;
    }
  }

  Future<double> getThisMonthTasks() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) =>
              isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
          .length
          .toDouble();
    } catch (e) {
      print('Error getting this month tasks: $e');
      return 0.0;
    }
  }

  Future<double> getMonthCompletedTasks() async {
    try {
      DateTime today = DateTime.now();
      await getTasks();
      return taskList
          .where((task) =>
              task.isCompleted == 1 &&
              isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
          .length
          .toDouble();
    } catch (e) {
      print('Error getting month completed tasks: $e');
      return 0.0;
    }
  }

  bool isWithinSameMonth(DateTime taskDate, DateTime today) {
    return taskDate.month == today.month && taskDate.year == today.year;
  }

  bool isWithinSevenDays(DateTime taskDate, DateTime today) {
    Duration difference = today.difference(taskDate);
    return difference.inDays <= 6;
  }
}
