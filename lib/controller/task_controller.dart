import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../model/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;
  var taskDetailList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DatabaseHelper.insertTask(task!);
  }

  var count = 0.obs;

  void updateCount(int newCount) {
    count.value = newCount;
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  Future<double> getTotalTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    res = taskList.length.toDouble();
    return res;
  }

  // get total completed tasks
  Future<double> getTotalCompletedTask() async {
    double res = 0;
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].isCompleted == 1) {
        res += 1;
      }
    }
    return res;
  }

  Future<int> getTotalCompletedProgress() async {
    int totalProgress = 0;
    double comp = await getTotalCompletedTask();
    double total = await getTotalTask();
    // use toInt() but not as int
    // totalProgress = ((comp / total) * 100) as int; // wrong
    totalProgress = ((comp / total) * 100).toInt();
    return totalProgress;
  }

  void undoTaskCompleted(int id) async {
    await DatabaseHelper.undoCompleted(id);
    getTasks(); // update the current new task list
  }

  void undoTaskStar(int id) async {
    await DatabaseHelper.undoStar(id);
    getTasks(); // update the current new task list
  }

  void delete(Task task) {
    DatabaseHelper.delete(task);
    getTasks();
  }

  // //
  // void isCompled() async {
  //   int value = await DatabaseHelper.query();
  // }

  void markTaskCompleted(int id) async {
    await DatabaseHelper.update(id);
    getTasks();
  }

  void markTaskStar(int id) async {
    await DatabaseHelper.markStar(id);
    getTasks(); // update the current new task list
  }

  @override
  void onInit() {
    super.onInit();
    getTasks();
    listenForTaskChanges();
  }

  void listenForTaskChanges() async {
    DatabaseHelper.initDb(); // Ensure database is initialized
    DatabaseHelper.listenForChanges((newCount) {
      updateCount(newCount);
    });
  }

  Future<double> getOneDayTask() async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    double res = taskList
        .where((task) => task.date == DateFormat.yMd().format(today))
        .length
        .toDouble();

    // using .where() to simplify the codes below:
    // double res = 0;
    // List<Map<String, dynamic>> tasks = await DBHelper.query();
    // taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    // for (int i = 0; i < taskList.length; i++) {
    //   if (taskList[i].date == DateFormat.yMd().format(today)) {
    //     res += 1;
    //   }
    // }
    return res;
  }

  Future<double> getOneDayCompletedTask() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].date == DateFormat.yMd().format(today) &&
          taskList[i].isCompleted == 1) {
        res += 1;
      }
    }
    return res;
  }

  // get total tasks under 7 days (started from today)
  Future<double> getSevenDaysTasks() async {
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    double res = taskList
        .where((task) =>
            isWithinSevenDays(DateFormat.yMd().parse(task.date!), today) &&
            isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
        .length
        .toDouble();
    return res;
  }

  Future<double> getSevenDaysCompletedTasks() async {
    DateTime today = DateTime.now();
    double res = taskList
        .where((task) =>
            task.isCompleted == 1 &&
            isWithinSevenDays(DateFormat.yMd().parse(task.date!), today) &&
            isWithinSameMonth(DateFormat.yMd().parse(task.date!), today))
        .length
        .toDouble();

    return res;
  }

  Future<double> getThisMonthTasks() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

    for (int i = 0; i < taskList.length; i++) {
      DateTime taskDate = DateFormat.yMd().parse(taskList[i].date!);
      if (isWithinSameMonth(taskDate, today)) {
        res += 1;
      }
    }

    return res;
  }

  Future<double> getMonthCompletedTasks() async {
    DateTime today = DateTime.now();
    double res = 0;
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

    for (int i = 0; i < taskList.length; i++) {
      DateTime taskDate = DateFormat.yMd().parse(taskList[i].date!);
      if (taskList[i].isCompleted == 1 && isWithinSameMonth(taskDate, today)) {
        res += 1;
      }
    }

    return res;
  }

  // judge logic
  bool isWithinSameMonth(DateTime taskDate, DateTime today) {
    return taskDate.month == today.month && taskDate.year == today.year;
  }

  bool isWithinSevenDays(DateTime taskDate, DateTime today) {
    Duration difference = today.difference(taskDate);
    return difference.inDays <= 6;
  }
}
