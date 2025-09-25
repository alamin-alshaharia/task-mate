// *** DEVELOPMENT/DEBUG ONLY FILE ***
// This file is for testing and debugging notification functionality
// It is only accessible in debug builds and should not be included in production releases

import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:flutter_task_planner_app/utils/notification_validator.dart';
import 'package:get/get.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotifyHelper _notifyHelper = NotifyHelper();
  String _testResult = "Ready to test notifications";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notifyHelper.ensureInitialized();
      setState(() {
        _testResult = "✅ Notifications initialized successfully";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to initialize notifications: $e";
      });
    }
  }

  Future<void> _testTaskNotification() async {
    setState(() {
      _testResult = "⏳ Testing task notification...";
    });

    try {
      // Create a test task
      final testTask = Task(
        id: 999,
        title: "Test Task Notification",
        description: "This is a test notification for task reminders",
        startTime: "12:00 PM",
        repeat: "Once",
        date: DateTime.now().toString(),
        color: 1,
        isCompleted: 0,
      );

      // Schedule notification for 10 seconds from now
      final now = DateTime.now();
      final scheduleTime = now.add(const Duration(seconds: 10));

      await _notifyHelper.scheduleNotificationAt(scheduleTime, testTask);

      setState(() {
        _testResult =
            "✅ Task notification scheduled for ${scheduleTime.toString().split('.')[0]}\n"
            "⏰ Should appear in exactly 10 seconds!\n"
            "Current time: ${now.toString().split('.')[0]}";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to schedule task notification: $e";
      });
    }
  }

  Future<void> _testInstantNotification() async {
    setState(() {
      _testResult = "⏳ Sending instant notification...";
    });

    try {
      await _notifyHelper.displayNotification(
        id: 998,
        title: "📋 Instant Task Test",
        body: "This is an instant task notification test! 🚀",
        payload: "test_instant",
      );

      setState(() {
        _testResult =
            "✅ Instant notification sent!\nCheck your notification panel.";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to send instant notification: $e";
      });
    }
  }

  Future<void> _testDailyNotification() async {
    setState(() {
      _testResult = "⏳ Testing daily notification...";
    });

    try {
      // Create a test task for daily reminder
      final testTask = Task(
        id: 997,
        title: "Daily Test Task",
        description: "This is a daily recurring test task",
        startTime: "09:00 AM",
        repeat: "Daily",
        date: DateTime.now().toString(),
        color: 2,
        isCompleted: 0,
      );

      // Schedule for tomorrow at 9 AM
      await _notifyHelper.scheduleDailyNotification(
        id: testTask.id!,
        title: testTask.title!,
        body: testTask.description!,
        hour: 9,
        minute: 0,
      );

      setState(() {
        _testResult = "✅ Daily notification scheduled for 9:00 AM\n"
            "You'll receive it daily at this time.";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to schedule daily notification: $e";
      });
    }
  }

  Future<void> _checkPendingNotifications() async {
    setState(() {
      _testResult = "⏳ Checking pending notifications...";
    });

    try {
      final pending = await _notifyHelper.getPendingNotifications();

      setState(() {
        _testResult =
            "📅 Found ${pending.length} pending notifications:\n\n${pending.map((notif) => "• ID: ${notif.id}\n"
                "  Title: ${notif.title ?? 'No title'}\n"
                "  Body: ${notif.body ?? 'No body'}\n").join('\n')}";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to check pending notifications: $e";
      });
    }
  }

  Future<void> _testNotificationPreferences() async {
    setState(() {
      _testResult = "⏳ Testing notification preferences...";
    });

    try {
      final notificationsEnabled =
          await _notifyHelper.areNotificationsEnabled();
      final soundEnabled = await _notifyHelper.isSoundEnabled();
      final vibrationEnabled = await _notifyHelper.isVibrationEnabled();

      setState(() {
        _testResult = "🔧 Notification Preferences:\n\n"
            "• Notifications: ${notificationsEnabled ? '✅ Enabled' : '❌ Disabled'}\n"
            "• Sound: ${soundEnabled ? '✅ Enabled' : '❌ Disabled'}\n"
            "• Vibration: ${vibrationEnabled ? '✅ Enabled' : '❌ Disabled'}";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Failed to check preferences: $e";
      });
    }
  }

  Future<void> _debugTimezone() async {
    setState(() {
      _testResult = "⏳ Debugging timezone and time information...";
    });

    try {
      // Initialize the notification service to trigger timezone setup
      await _notifyHelper.ensureInitialized();

      // Get system time information
      final now = DateTime.now();
      final timeZoneName = now.timeZoneName;
      final timeZoneOffset = now.timeZoneOffset;

      setState(() {
        _testResult = "🌍 Timezone Debug Information:\n\n"
            "📅 System Date/Time: ${now.toString().split('.')[0]}\n"
            "🌐 Timezone Name: $timeZoneName\n"
            "⏰ UTC Offset: $timeZoneOffset\n"
            "🌎 Is UTC: ${now.isUtc}\n\n"
            "Check console logs for detailed timezone\n"
            "configuration information from the\n"
            "notification service.";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Timezone debug failed: $e";
      });
    }
  }

  Future<void> _testTaskCreationFlow() async {
    setState(() {
      _testResult =
          "⏳ Testing complete task creation with notification scheduling...";
    });

    try {
      final success =
          await NotificationValidator.testTaskCreationWithNotification();

      setState(() {
        if (success) {
          _testResult = "✅ Task Creation Flow Test - PASSED!\n\n"
              "• Task created successfully\n"
              "• Notification automatically scheduled\n"
              "• Task removed after test\n\n"
              "Task creation page should now properly\n"
              "schedule notifications for new tasks!";
        } else {
          _testResult = "❌ Task Creation Flow Test - FAILED!\n\n"
              "The task was created but notification\n"
              "scheduling may not be working properly.\n"
              "Check console for more details.";
        }
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Task creation test failed: $e";
      });
    }
  }

  Future<void> _runFullValidation() async {
    setState(() {
      _testResult = "⏳ Running comprehensive validation tests...\n";
    });

    try {
      final results = await NotificationValidator.runNotificationTests();

      final passedTests = results.values.where((result) => result).length;
      final totalTests = results.length;

      setState(() {
        _testResult =
            "📊 Validation Complete!\n\n✅ Passed: $passedTests/$totalTests tests\n📈 Success Rate: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%\n\nTest Results:\n${results.entries.map((entry) => "• ${entry.key}: ${entry.value ? '✅ PASS' : '❌ FAIL'}").join('\n')}\n\n${passedTests == totalTests ? '🎉 All systems operational!' : '⚠️ Some issues detected - check logs'}";
      });
    } catch (e) {
      setState(() {
        _testResult = "❌ Validation failed with error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Notification Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Results:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _testResult,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ElevatedButton.icon(
                    onPressed: _debugTimezone,
                    icon: const Icon(Icons.public),
                    label: const Text('Debug Timezone & Time'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testInstantNotification,
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Test Instant Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testTaskNotification,
                    icon: const Icon(Icons.schedule),
                    label: const Text('Test Scheduled Task (10s delay)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testDailyNotification,
                    icon: const Icon(Icons.repeat),
                    label: const Text('Test Daily Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testTaskCreationFlow,
                    icon: const Icon(Icons.add_task),
                    label: const Text('Test Task Creation + Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _runFullValidation,
                    icon: const Icon(Icons.verified),
                    label: const Text('Run Full Validation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _checkPendingNotifications,
                    icon: const Icon(Icons.list),
                    label: const Text('Check Pending Notifications'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _testNotificationPreferences,
                    icon: const Icon(Icons.settings),
                    label: const Text('Check Preferences'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _notifyHelper.cancelAllNotifications();
                      Get.snackbar(
                        "Cleared! 🧹",
                        "All test notifications cancelled",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      setState(() {
                        _testResult = "🧹 All notifications cleared";
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All Notifications'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
