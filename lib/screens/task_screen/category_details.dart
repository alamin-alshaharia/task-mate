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
    final categoryColor =
        Color(int.parse(widget.category.color.replaceAll('#', '0xff')));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: _getCategoryGradient(categoryColor),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
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

      final categoryColor =
          Color(int.parse(widget.category.color.replaceAll('#', '0xff')));

      return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withOpacity(0.1),
              categoryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: categoryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
    final categoryColor =
        Color(int.parse(widget.category.color.replaceAll('#', '0xff')));
    final statColor = color ?? categoryColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            statColor.withOpacity(0.1),
            statColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statColor.withOpacity(0.2),
                  statColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: statColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: statColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      // Filter tasks for this category from the reactive task list
      final categoryTasks = _taskController.taskList
          .where((task) => task.categoryId == widget.category.id)
          .toList();

      if (categoryTasks.isEmpty) {
        final categoryColor =
            Color(int.parse(widget.category.color.replaceAll('#', '0xff')));

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.1),
                      categoryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.task_outlined,
                  size: 60,
                  color: categoryColor.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'No tasks in this category',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first task to get started',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNewTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('Add First Task'),
                  ],
                ),
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

  LinearGradient _getCategoryGradient(Color baseColor) {
    // Create beautiful gradients based on the base color
    final hsl = HSLColor.fromColor(baseColor);
    final lightColor =
        hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    final darkColor =
        hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, baseColor, darkColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  void _addNewTask() {
    // Navigate to create task page with pre-selected category
    Get.to(() => CreateNewTaskPage(
          preSelectedCategory: widget.category,
        ));
  }
}
