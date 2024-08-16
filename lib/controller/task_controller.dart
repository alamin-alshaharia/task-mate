import 'package:get/get.dart';

import '../Db/database_helper.dart';
import '../model/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;
  Future<int> addTask({Task? task}) async {
    return await DatabaseHelper.insertTask(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DatabaseHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DatabaseHelper.update(id);
    getTasks();
  }
}
