import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

import '../../controller/task_controller.dart';
import '../../model/category_model.dart';
import '../../model/task_model.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final TaskController _taskController = Get.find();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    // _tasks = await _taskController.getTasksByCategory(widget.category.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor:
            Color(int.parse(widget.category.color.replaceAll('#', '0xff'))),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewTask,
          ),
        ],
      ),
      body: _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'No tasks in this category',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addNewTask,
              child: Text('Add First Task'),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTaskCard(task),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title ?? 'Untitled Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted == 1 ? Colors.grey : Colors.black,
                      decoration: task.isCompleted == 1
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                _buildTaskStatusIcon(task),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description ?? 'No description',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            _buildDateChip(task),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusIcon(Task task) {
    return IconButton(
      icon: Icon(
        task.isCompleted == 1 ? Icons.check_circle : Icons.circle_outlined,
        color: task.isCompleted == 1 ? Colors.green : Colors.grey,
      ),
      onPressed: () {
        // Toggle task completion
        _toggleTaskCompletion(task);
      },
    );
  }

  Widget _buildDateChip(Task task) {
    return Chip(
      label: Text(
        task.date != null
            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(task.date!))
            : 'No Date',
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _toggleTaskCompletion(Task task) {
    if (task.isCompleted == 1) {
      _taskController.undoTaskCompleted(task.id!);
    } else {
      _taskController.markTaskCompleted(task.id!);
    }
    _loadTasks();
  }

  void _addNewTask() {
    // Navigate to create task page with pre-selected category
    Get.to(() => CreateNewTaskPage(
          preSelectedCategory: widget.category,
        ));
  }
}
