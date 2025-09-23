import 'package:flutter_task_planner_app/controller/profile_controller.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/db/database_helper.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:get/get.dart';

/// Centralized Data Manager for handling cross-page data synchronization
/// This ensures all pages stay in sync when data changes occur
class DataSyncManager extends GetxController {
  static DataSyncManager get instance => Get.find<DataSyncManager>();

  // Controllers
  late TaskController _taskController;
  late ProfileController _profileController;

  // Reactive states for UI updates
  final RxBool isLoading = false.obs;
  final RxBool isTaskSyncing = false.obs;
  final RxBool isProfileSyncing = false.obs;
  final RxString lastSyncTime = ''.obs;

  // UI refresh callbacks
  final List<Function()> _homePageRefreshCallbacks = [];
  final List<Function()> _taskListRefreshCallbacks = [];
  final List<Function()> _categoryRefreshCallbacks = [];

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    AppLogger.d('DataSyncManager initialized');
  }

  void _initializeControllers() {
    try {
      _taskController = Get.find<TaskController>();
      _profileController = Get.find<ProfileController>();
    } catch (e) {
      AppLogger.e('Error initializing controllers in DataSyncManager: $e');
    }
  }

  /// Sync all data across the application
  Future<void> syncAllData() async {
    if (isLoading.value) return; // Prevent multiple sync operations

    try {
      isLoading.value = true;
      AppLogger.d('Starting full data sync');

      // Sync tasks and categories
      await syncTaskData();

      // Sync profile data
      await syncProfileData();

      lastSyncTime.value = DateTime.now().toIso8601String();
      AppLogger.d('Full data sync completed successfully');
    } catch (e) {
      AppLogger.e('Error during full data sync: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sync task-related data (tasks and categories)
  Future<void> syncTaskData() async {
    if (isTaskSyncing.value) return;

    try {
      isTaskSyncing.value = true;
      AppLogger.d('Syncing task data');

      // Refresh tasks from database
      await _taskController.getTasks();

      // Refresh categories from database
      await _taskController.getCategories();

      AppLogger.d(
          'Task data sync completed - Tasks: ${_taskController.taskList.length}, Categories: ${_taskController.categoryList.length}');
    } catch (e) {
      AppLogger.e('Error syncing task data: $e');
      rethrow;
    } finally {
      isTaskSyncing.value = false;
    }
  }

  /// Sync profile data
  Future<void> syncProfileData() async {
    if (isProfileSyncing.value) return;

    try {
      isProfileSyncing.value = true;
      AppLogger.d('Syncing profile data');

      // Refresh profile from database
      await _profileController.fetchProfile();

      AppLogger.d('Profile data sync completed');
    } catch (e) {
      AppLogger.e('Error syncing profile data: $e');
      rethrow;
    } finally {
      isProfileSyncing.value = false;
    }
  }

  /// Register callbacks for UI refresh
  void registerHomePageRefreshCallback(Function() callback) {
    _homePageRefreshCallbacks.add(callback);
  }

  void unregisterHomePageRefreshCallback(Function() callback) {
    _homePageRefreshCallbacks.remove(callback);
  }

  void registerTaskListRefreshCallback(Function() callback) {
    _taskListRefreshCallbacks.add(callback);
  }

  void unregisterTaskListRefreshCallback(Function() callback) {
    _taskListRefreshCallbacks.remove(callback);
  }

  void registerCategoryRefreshCallback(Function() callback) {
    _categoryRefreshCallbacks.add(callback);
  }

  void unregisterCategoryRefreshCallback(Function() callback) {
    _categoryRefreshCallbacks.remove(callback);
  }

  /// Notify all registered callbacks
  void _notifyAllCallbacks() {
    for (var callback in _homePageRefreshCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.e('Error in home page refresh callback: $e');
      }
    }

    for (var callback in _taskListRefreshCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.e('Error in task list refresh callback: $e');
      }
    }

    for (var callback in _categoryRefreshCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.e('Error in category refresh callback: $e');
      }
    }
  }

  /// Handle task creation with proper sync
  Future<void> createTask(Task task) async {
    try {
      AppLogger.d('Creating task with sync: ${task.title}');

      // Add task through controller
      await _taskController.addTask(task: task);

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Task created and synced successfully');
    } catch (e) {
      AppLogger.e('Error creating task with sync: $e');
      rethrow;
    }
  }

  /// Handle task update with proper sync
  Future<void> updateTask(Task task) async {
    try {
      AppLogger.d('Updating task with sync: ${task.title}');

      // Update task through controller
      _taskController.updateTask(task: task);

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Task updated and synced successfully');
    } catch (e) {
      AppLogger.e('Error updating task with sync: $e');
      rethrow;
    }
  }

  /// Handle task deletion with proper sync
  Future<void> deleteTask(Task task) async {
    try {
      AppLogger.d('Deleting task with sync: ${task.title}');

      // Delete task through controller
      _taskController.delete(task);

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Task deleted and synced successfully');
    } catch (e) {
      AppLogger.e('Error deleting task with sync: $e');
      rethrow;
    }
  }

  /// Handle task completion toggle with proper sync
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      AppLogger.d(
          'Toggling task completion with sync: ${task.title} - New status: ${task.isCompleted}');

      // Update the task directly with the new data
      _taskController.updateTask(task: task);

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Task completion toggled and synced successfully');
    } catch (e) {
      AppLogger.e('Error toggling task completion with sync: $e');
      rethrow;
    }
  }

  /// Handle task star toggle with proper sync
  Future<void> toggleTaskStar(Task task) async {
    try {
      AppLogger.d(
          'Toggling task star with sync: ${task.title} - New star status: ${task.isStar}');

      // Update the task directly with the new data
      _taskController.updateTask(task: task);

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Task star toggled and synced successfully');
    } catch (e) {
      AppLogger.e('Error toggling task star with sync: $e');
      rethrow;
    }
  }

  /// Handle category creation with proper sync
  Future<void> createCategory({
    required String name,
    required String icon,
    required String color,
  }) async {
    try {
      AppLogger.d('Creating category with sync: $name');

      // Add category through controller
      await _taskController.addCategory(
        name: name,
        icon: icon,
        color: color,
      );

      // Sync all task data to update UI everywhere
      await syncTaskData();

      // Notify all UI components to refresh
      _notifyAllCallbacks();

      AppLogger.d('Category created and synced successfully');
    } catch (e) {
      AppLogger.e('Error creating category with sync: $e');
      rethrow;
    }
  }

  /// Handle category deletion with proper sync
  Future<void> deleteCategory(int categoryId) async {
    try {
      AppLogger.d('Deleting category with sync: $categoryId');

      // Delete category through controller
      final success = await _taskController.deleteCategory(categoryId);

      if (success) {
        // Sync all task data to update UI everywhere
        await syncTaskData();

        // Notify all UI components to refresh
        _notifyAllCallbacks();

        AppLogger.d('Category deleted and synced successfully');
      } else {
        AppLogger.w('Category deletion failed - may have associated tasks');
        throw Exception('Cannot delete category with associated tasks');
      }
    } catch (e) {
      AppLogger.e('Error deleting category with sync: $e');
      rethrow;
    }
  }

  /// Handle profile update with proper sync
  Future<void> updateProfile({
    String? name,
    String? profession,
    dynamic imageData,
  }) async {
    try {
      AppLogger.d('Updating profile with sync');

      // Update profile through controller
      _profileController.profile.update((profile) {
        if (name != null) profile?.name = name;
        if (profession != null) profile?.profession = profession;
        if (imageData != null) profile?.imageData = imageData;
      });

      // Save to database
      await _profileController.saveProfile();

      // Sync profile data to update UI everywhere
      await syncProfileData();

      AppLogger.d('Profile updated and synced successfully');
    } catch (e) {
      AppLogger.e('Error updating profile with sync: $e');
      rethrow;
    }
  }

  /// Handle bulk operations with proper sync
  Future<void> deleteAllTasks() async {
    try {
      AppLogger.d('Deleting all tasks with sync');

      // Delete all tasks through controller
      await _taskController.deleteAllTasks();

      // Sync all data to update UI everywhere
      await syncAllData();

      AppLogger.d('All tasks deleted and synced successfully');
    } catch (e) {
      AppLogger.e('Error deleting all tasks with sync: $e');
      rethrow;
    }
  }

  /// Handle complete data reset with proper sync
  Future<void> clearAllData() async {
    try {
      AppLogger.d('Clearing all data with sync');

      // Clear data through database
      await DatabaseHelper.instance.clearAllData();

      // Clear profile
      _profileController.profile.update((profile) {
        profile?.name = '';
        profile?.profession = '';
        profile?.imageData = null;
      });
      await _profileController.saveProfile();

      // Sync all data to update UI everywhere
      await syncAllData();

      AppLogger.d('All data cleared and synced successfully');
    } catch (e) {
      AppLogger.e('Error clearing all data with sync: $e');
      rethrow;
    }
  }

  /// Force refresh all UI components
  void forceRefreshUI() {
    AppLogger.d('Force refreshing UI components');

    // Trigger reactive updates
    _taskController.taskList.refresh();
    _taskController.categoryList.refresh();
    _profileController.profile.refresh();

    AppLogger.d('UI force refresh completed');
  }

  /// Get current sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'isLoading': isLoading.value,
      'isTaskSyncing': isTaskSyncing.value,
      'isProfileSyncing': isProfileSyncing.value,
      'lastSyncTime': lastSyncTime.value,
      'taskCount': _taskController.taskList.length,
      'categoryCount': _taskController.categoryList.length,
      'profileName': _profileController.profile.value.name ?? 'No name',
    };
  }
}
