import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/task_tile.dart';
import 'package:get/get.dart';

import '../../controller/task_controller.dart';
import '../../model/category_model.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final TaskController _taskController = Get.find();

  @override
  void initState() {
    super.initState();
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
      body: Column(
        children: [
          _buildTaskStats(),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildTaskStats() {
    return Obx(() {
      // Filter tasks for this category from the reactive task list
      final categoryTasks = _taskController.taskList
          .where((task) => task.categoryId == widget.category.id)
          .toList();

      final totalTasks = categoryTasks.length;
      final completedTasks =
          categoryTasks.where((task) => task.isCompleted == 1).length;
      final remainingTasks = totalTasks - completedTasks;

      return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(int.parse(widget.category.color.replaceAll('#', '0xff')))
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                Color(int.parse(widget.category.color.replaceAll('#', '0xff')))
                    .withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', totalTasks, Icons.list_alt),
            _buildStatItem(
                'Left', remainingTasks, Icons.pending_actions, Colors.orange),
            _buildStatItem(
                'Done', completedTasks, Icons.check_circle, Colors.green),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, int count, IconData icon,
      [Color? color]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color ?? Colors.grey[600],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      // Filter tasks for this category from the reactive task list
      final categoryTasks = _taskController.taskList
          .where((task) => task.categoryId == widget.category.id)
          .toList();

      if (categoryTasks.isEmpty) {
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
          itemCount: categoryTasks.length,
          itemBuilder: (context, index) {
            final task = categoryTasks[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: TaskTile(task),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _addNewTask() {
    // Navigate to create task page with pre-selected category
    Get.to(() => CreateNewTaskPage(
          preSelectedCategory: widget.category,
        ));
  }
}
