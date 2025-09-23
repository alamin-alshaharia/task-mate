import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/data_sync_manager.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskBottomSheet {
  static void show(
    BuildContext context,
    Task task, {
    bool showDetails = false,
    bool showStar = false,
  }) {
    final TaskController taskController = Get.find();
    final DataSyncManager dataSyncManager = Get.find();

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Task info header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTaskColor(task).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.task_alt,
                      color: _getTaskColor(task),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title ?? 'Untitled Task',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.description?.isNotEmpty == true)
                          Text(
                            task.description!,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted == 1
                          ? Colors.green[100]
                          : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.isCompleted == 1 ? 'Completed' : 'Pending',
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        color: task.isCompleted == 1
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Edit action
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit Task',
                    color: Colors.blue,
                    onTap: () {
                      Get.back();
                      Get.to(() => CreateNewTaskPage(editingTask: task));
                    },
                  ),

                  const SizedBox(height: 12),

                  // Completion action
                  _buildActionButton(
                    icon:
                        task.isCompleted == 1 ? Icons.undo : Icons.check_circle,
                    label: task.isCompleted == 1
                        ? 'Mark as Pending'
                        : 'Mark as Completed',
                    color: task.isCompleted == 1 ? Colors.orange : Colors.green,
                    onTap: () async {
                      // Create updated task with toggled completion status
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        date: task.date,
                        startTime: task.startTime,
                        endTime: task.endTime,
                        remind: task.remind,
                        repeat: task.repeat,
                        color: task.color,
                        isCompleted: task.isCompleted == 1 ? 0 : 1,
                        isStar: task.isStar,
                        categoryId: task.categoryId,
                      );

                      // Use DataSyncManager for centralized sync
                      await dataSyncManager.toggleTaskCompletion(updatedTask);
                      Get.back();
                    },
                  ),

                  const SizedBox(height: 12),

                  // Star action (if enabled)
                  if (showStar) ...[
                    _buildActionButton(
                      icon: task.isStar == 1 ? Icons.star : Icons.star_border,
                      label: task.isStar == 1
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                      color: Colors.amber,
                      onTap: () async {
                        // Create updated task with toggled star status
                        final updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          date: task.date,
                          startTime: task.startTime,
                          endTime: task.endTime,
                          remind: task.remind,
                          repeat: task.repeat,
                          color: task.color,
                          isCompleted: task.isCompleted,
                          isStar: task.isStar == 1 ? 0 : 1,
                          categoryId: task.categoryId,
                        );

                        // Use DataSyncManager for centralized sync
                        await dataSyncManager.toggleTaskStar(updatedTask);
                        Get.back();
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Details action (if enabled)
                  if (showDetails) ...[
                    _buildActionButton(
                      icon: Icons.visibility,
                      label: 'View Details',
                      color: Colors.blue,
                      isOutlined: true,
                      onTap: () async {
                        Get.back();
                        await Get.to(() => CreateNewTaskPage());
                        // Data sync will be handled automatically by CreateNewTaskPage
                        await dataSyncManager.syncAllData();
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Delete action
                  _buildActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete Task',
                    color: Colors.red,
                    isDestructive: true,
                    onTap: () {
                      _showDeleteConfirmation(context, task, taskController);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : isDestructive
                  ? Colors.red[50]
                  : color.withOpacity(0.1),
          border: Border.all(
            color: isDestructive ? Colors.red[300]! : color.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red[600] : color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDestructive ? Colors.red[600] : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showDeleteConfirmation(
    BuildContext context,
    Task task,
    TaskController taskController,
  ) {
    final DataSyncManager dataSyncManager = Get.find();
    Get.back(); // Close the main bottom sheet first

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[600], size: 24),
            const SizedBox(width: 8),
            Text(
              'Delete Task',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this task?',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.title ?? 'Untitled Task',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.red[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.lato(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Use DataSyncManager for centralized sync
              await dataSyncManager.deleteTask(task);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _getTaskColor(Task task) {
    if (task.color != null) {
      switch (task.color) {
        case 0:
          return Colors.blue;
        case 1:
          return Colors.pink;
        case 2:
          return Colors.yellow[700]!;
        default:
          return Colors.blue;
      }
    }
    return Colors.blue;
  }
}
