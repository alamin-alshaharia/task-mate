// *** DEVELOPMENT/DEBUG ONLY FILE ***
// This utility class is for testing and validating notification functionality
// It should only be used during development and debugging

import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:flutter_task_planner_app/utils/time_parser.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// This is a simple test script to validate task notification functionality
/// Run this from your app to test notifications (DEBUG BUILDS ONLY)
class NotificationValidator {
  static final NotifyHelper _notifyHelper = NotifyHelper();

  /// Test basic notification functionality
  static Future<Map<String, bool>> runNotificationTests() async {
    print('🧪 Starting notification validation tests...\n');

    final results = <String, bool>{};

    // Test 1: Initialization
    try {
      await _notifyHelper.ensureInitialized();
      results['initialization'] = true;
      print('✅ Test 1: Notification initialization - PASSED');
    } catch (e) {
      results['initialization'] = false;
      print('❌ Test 1: Notification initialization - FAILED: $e');
    }

    // Test 2: Preferences
    try {
      final notificationsEnabled =
          await _notifyHelper.areNotificationsEnabled();
      final soundEnabled = await _notifyHelper.isSoundEnabled();
      final vibrationEnabled = await _notifyHelper.isVibrationEnabled();

      results['preferences'] = true;
      print('✅ Test 2: Preferences check - PASSED');
      print('   - Notifications: $notificationsEnabled');
      print('   - Sound: $soundEnabled');
      print('   - Vibration: $vibrationEnabled');
    } catch (e) {
      results['preferences'] = false;
      print('❌ Test 2: Preferences check - FAILED: $e');
    }

    // Test 3: Instant notification
    try {
      await _notifyHelper.displayNotification(
        id: 9999,
        title: '🧪 Test Notification',
        body: 'This is a validation test notification',
        payload: 'test_validation',
      );
      results['instant_notification'] = true;
      print('✅ Test 3: Instant notification - PASSED');
    } catch (e) {
      results['instant_notification'] = false;
      print('❌ Test 3: Instant notification - FAILED: $e');
    }

    // Test 4: Task notification scheduling
    try {
      final testTask = Task(
        id: 9998,
        title: 'Test Task Notification',
        description: 'This is a test task for notification validation',
        startTime: '10:30 AM',
        repeat: 'Once',
        date: DateTime.now().toString(),
        color: 1,
        isCompleted: 0,
      );

      // Schedule for 3 minutes from now (using immediate scheduling)
      final now = DateTime.now();
      final scheduleTime = now.add(const Duration(minutes: 3));

      await _notifyHelper.scheduleNotificationAt(scheduleTime, testTask);

      results['task_notification'] = true;
      print('✅ Test 4: Task notification scheduling - PASSED');
      print('   - Scheduled for: ${DateFormat('HH:mm').format(scheduleTime)}');
    } catch (e) {
      results['task_notification'] = false;
      print('❌ Test 4: Task notification scheduling - FAILED: $e');
    }

    // Test 5: Daily notification
    try {
      await _notifyHelper.scheduleDailyNotification(
        id: 9997,
        title: 'Daily Test Reminder',
        body: 'This is a daily test notification',
        hour: 9,
        minute: 0,
      );
      results['daily_notification'] = true;
      print('✅ Test 5: Daily notification - PASSED');
    } catch (e) {
      results['daily_notification'] = false;
      print('❌ Test 5: Daily notification - FAILED: $e');
    }

    // Test 6: Pending notifications check
    try {
      final pending = await _notifyHelper.getPendingNotifications();
      results['pending_check'] = true;
      print('✅ Test 6: Pending notifications check - PASSED');
      print('   - Found ${pending.length} pending notifications');
    } catch (e) {
      results['pending_check'] = false;
      print('❌ Test 6: Pending notifications check - FAILED: $e');
    }

    // Test 7: Time parsing (simulate real task scenario)
    try {
      final testTimes = ['09:30 AM', '02:15 PM', '11:45 PM'];
      for (final timeStr in testTimes) {
        // Use the new TimeParser utility
        final parsed = TimeParser.parseTimeToHoursMinutes(timeStr);
        print(
            '   ✓ Parsed $timeStr → ${parsed.hours}:${parsed.minutes.toString().padLeft(2, '0')}');
      }
      results['time_parsing'] = true;
      print('✅ Test 7: Time parsing - PASSED');
    } catch (e) {
      results['time_parsing'] = false;
      print('❌ Test 7: Time parsing - FAILED: $e');
    }

    // Summary
    final passedTests = results.values.where((result) => result).length;
    final totalTests = results.length;

    print('\n📊 Test Summary:');
    print('   Passed: $passedTests/$totalTests');
    print(
        '   Success Rate: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

    if (passedTests == totalTests) {
      print('🎉 All tests passed! Task notifications should work properly.');
    } else {
      print('⚠️  Some tests failed. Check the specific failures above.');
    }

    return results;
  }

  /// Test a specific task notification scenario
  static Future<bool> testTaskNotificationScenario(Task task) async {
    print('🔍 Testing notification for specific task: ${task.title}');

    try {
      // Parse the task's start time
      if (task.startTime == null) {
        print('❌ Task start time is null');
        return false;
      }

      // Use the new TimeParser utility
      final parsed = TimeParser.parseTimeToHoursMinutes(task.startTime!);
      final hours = parsed.hours;
      final minutes = parsed.minutes;

      print(
          '   Parsed time: $hours:${minutes.toString().padLeft(2, '0')} from ${task.startTime}');

      // Schedule the notification
      await _notifyHelper.scheduledNotification(hours, minutes, task);

      print('✅ Task notification scheduled successfully');
      return true;
    } catch (e) {
      print('❌ Failed to schedule task notification: $e');
      return false;
    }
  }

  /// Test immediate notification scheduling (for short delays)
  static Future<bool> testImmediateNotification(
      Task task, Duration delay) async {
    print(
        '🔍 Testing immediate notification for task: ${task.title} (delay: ${delay.inSeconds}s)');

    try {
      final scheduleTime = DateTime.now().add(delay);
      await _notifyHelper.scheduleNotificationAt(scheduleTime, task);

      print(
          '✅ Immediate notification scheduled for ${scheduleTime.toString().split('.')[0]}');
      return true;
    } catch (e) {
      print('❌ Failed to schedule immediate notification: $e');
      return false;
    }
  }

  /// Test full task creation flow with notification scheduling
  static Future<bool> testTaskCreationWithNotification() async {
    print(
        '🔍 Testing complete task creation flow with notification scheduling...');

    try {
      // Import task controller for testing
      final taskController = Get.find<TaskController>();

      // Create a test task with notification settings
      final testTask = Task(
        title: 'Notification Test Task',
        description:
            'Testing automatic notification scheduling on task creation',
        startTime: '10:30 AM',
        remind: 15, // 15 minutes before
        repeat: 'Once',
        date: DateFormat.yMd().format(DateTime.now()),
        color: 1,
        isCompleted: 0,
      );

      print('   Creating task: ${testTask.title}');
      print('   Start time: ${testTask.startTime}');
      print('   Reminder: ${testTask.remind} minutes before');

      // Add task through controller (should automatically schedule notification)
      await taskController.addTask(task: testTask);

      // Check if notification was scheduled by looking at pending notifications
      final pendingNotifications =
          await _notifyHelper.getPendingNotifications();
      final taskNotificationFound = pendingNotifications.any((notification) =>
          notification.title?.contains(testTask.title!) ?? false);

      if (taskNotificationFound) {
        print('✅ Task creation with notification scheduling - PASSED');
        print('   - Task created successfully');
        print('   - Notification automatically scheduled');
        print('   - Found in pending notifications list');

        // Clean up test task
        final createdTasks = taskController.taskList
            .where((t) => t.title == testTask.title)
            .toList();
        if (createdTasks.isNotEmpty) {
          taskController.delete(createdTasks.first);
          print('   - Test task cleaned up');
        }

        return true;
      } else {
        print('❌ Task creation with notification scheduling - FAILED');
        print('   - Task created but notification not found in pending list');
        return false;
      }
    } catch (e) {
      print('❌ Task creation with notification scheduling - FAILED: $e');
      return false;
    }
  }

  /// Clean up test notifications
  static Future<void> cleanupTestNotifications() async {
    try {
      // Cancel specific test notifications
      await _notifyHelper.cancelNotification(9999);
      await _notifyHelper.cancelNotification(9998);
      await _notifyHelper.cancelNotification(9997);

      print('🧹 Test notifications cleaned up');
    } catch (e) {
      print('⚠️  Error cleaning up test notifications: $e');
    }
  }
}
