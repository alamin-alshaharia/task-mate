import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/data_sync_manager.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';

/// Mixin for screens that need data synchronization
/// Provides common data operations with automatic UI updates
mixin DataSyncMixin<T extends StatefulWidget> on State<T> {
  /// Get the DataSyncManager instance
  DataSyncManager get dataSyncManager => DataSyncManager.instance;

  /// Loading state for UI feedback
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Set loading state and update UI
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Show loading indicator
  void showLoading() => setLoading(true);

  /// Hide loading indicator
  void hideLoading() => setLoading(false);

  /// Execute an operation with loading state management
  Future<T?> withLoading<T>(Future<T> Function() operation) async {
    try {
      showLoading();
      final result = await operation();
      return result;
    } catch (e) {
      AppLogger.e('Error in operation with loading: $e');
      _showErrorSnackbar('Operation failed: $e');
      return null;
    } finally {
      hideLoading();
    }
  }

  /// Create a new task with automatic sync
  Future<void> createTaskWithSync(Task task) async {
    await withLoading(() async {
      await dataSyncManager.createTask(task);
      _showSuccessSnackbar('Task created successfully');
    });
  }

  /// Update a task with automatic sync
  Future<void> updateTaskWithSync(Task task) async {
    await withLoading(() async {
      await dataSyncManager.updateTask(task);
      _showSuccessSnackbar('Task updated successfully');
    });
  }

  /// Delete a task with automatic sync
  Future<void> deleteTaskWithSync(Task task) async {
    await withLoading(() async {
      await dataSyncManager.deleteTask(task);
      _showSuccessSnackbar('Task deleted successfully');
    });
  }

  /// Toggle task completion with automatic sync
  Future<void> toggleTaskCompletionWithSync(Task task) async {
    await withLoading(() async {
      await dataSyncManager.toggleTaskCompletion(task);
      final status = task.isCompleted == 1 ? 'incomplete' : 'completed';
      _showSuccessSnackbar('Task marked as $status');
    });
  }

  /// Toggle task star with automatic sync
  Future<void> toggleTaskStarWithSync(Task task) async {
    await withLoading(() async {
      await dataSyncManager.toggleTaskStar(task);
      final status = task.isStar == 1 ? 'removed from' : 'added to';
      _showSuccessSnackbar('Task $status favorites');
    });
  }

  /// Create a new category with automatic sync
  Future<void> createCategoryWithSync({
    required String name,
    required String icon,
    required String color,
  }) async {
    await withLoading(() async {
      await dataSyncManager.createCategory(
        name: name,
        icon: icon,
        color: color,
      );
      _showSuccessSnackbar('Category created successfully');
    });
  }

  /// Delete a category with automatic sync
  Future<void> deleteCategoryWithSync(int categoryId) async {
    await withLoading(() async {
      await dataSyncManager.deleteCategory(categoryId);
      _showSuccessSnackbar('Category deleted successfully');
    });
  }

  /// Update profile with automatic sync
  Future<void> updateProfileWithSync({
    String? name,
    String? profession,
    dynamic imageData,
  }) async {
    await withLoading(() async {
      await dataSyncManager.updateProfile(
        name: name,
        profession: profession,
        imageData: imageData,
      );
      _showSuccessSnackbar('Profile updated successfully');
    });
  }

  /// Sync all data manually
  Future<void> syncAllData() async {
    await withLoading(() async {
      await dataSyncManager.syncAllData();
      _showSuccessSnackbar('Data synchronized successfully');
    });
  }

  /// Refresh current screen data
  Future<void> refreshScreenData() async {
    try {
      showLoading();
      await dataSyncManager.syncAllData();
      if (mounted) {
        setState(() {
          // Trigger rebuild to reflect new data
        });
      }
    } catch (e) {
      AppLogger.e('Error refreshing screen data: $e');
      _showErrorSnackbar('Failed to refresh data');
    } finally {
      hideLoading();
    }
  }

  /// Show confirmation dialog for destructive actions
  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(confirmText),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Delete task with confirmation
  Future<void> deleteTaskWithConfirmation(Task task) async {
    final confirmed = await showConfirmationDialog(
      title: 'Delete Task',
      message: 'Are you sure you want to delete "${task.title}"?',
      confirmText: 'Delete',
    );

    if (confirmed) {
      await deleteTaskWithSync(task);
    }
  }

  /// Delete category with confirmation
  Future<void> deleteCategoryWithConfirmation(
      int categoryId, String categoryName) async {
    final confirmed = await showConfirmationDialog(
      title: 'Delete Category',
      message:
          'Are you sure you want to delete "$categoryName"? This action cannot be undone.',
      confirmText: 'Delete',
    );

    if (confirmed) {
      await deleteCategoryWithSync(categoryId);
    }
  }

  /// Clear all data with confirmation
  Future<void> clearAllDataWithConfirmation() async {
    final confirmed = await showConfirmationDialog(
      title: 'Clear All Data',
      message:
          'This will permanently delete all your tasks and profile data. This action cannot be undone.',
      confirmText: 'Clear All',
    );

    if (confirmed) {
      await withLoading(() async {
        await dataSyncManager.clearAllData();
        _showSuccessSnackbar('All data cleared successfully');
      });
    }
  }

  /// Show success message
  void _showSuccessSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Show error message
  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Build a loading widget
  Widget buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build a loading overlay
  Widget buildLoadingOverlay({required Widget child}) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  /// Initialize screen with data sync
  @mustCallSuper
  void initializeDataSync() {
    // Listen to connectivity changes or other events
    // Refresh data when screen becomes visible
    refreshScreenData();
  }

  /// Cleanup when screen is disposed
  @mustCallSuper
  void disposeDataSync() {
    // Cleanup any listeners or subscriptions
  }
}
