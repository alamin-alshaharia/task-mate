import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';
import 'package:get/get.dart';

class NotificationStatusChecker extends StatefulWidget {
  const NotificationStatusChecker({super.key});

  @override
  State<NotificationStatusChecker> createState() =>
      _NotificationStatusCheckerState();
}

class _NotificationStatusCheckerState extends State<NotificationStatusChecker> {
  final NotifyHelper _notifyHelper = NotifyHelper();
  final List<String> _statusChecks = [];
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _performNotificationCheck();
  }

  Future<void> _performNotificationCheck() async {
    setState(() {
      _isChecking = true;
      _statusChecks.clear();
    });

    try {
      // 1. Check initialization
      _addStatus("🔧 Initializing notification service...");
      await _notifyHelper.ensureInitialized();
      _addStatus("✅ Notification service initialized successfully");

      // 2. Check permissions
      _addStatus("🔐 Checking notification permissions...");
      final isEnabled = await _notifyHelper.areNotificationsEnabled();
      _addStatus(isEnabled
          ? "✅ Notifications are enabled"
          : "⚠️ Notifications are disabled");

      // 3. Check sound settings
      final soundEnabled = await _notifyHelper.isSoundEnabled();
      _addStatus(soundEnabled
          ? "🔊 Sound notifications enabled"
          : "🔇 Sound notifications disabled");

      // 4. Check vibration settings
      final vibrationEnabled = await _notifyHelper.isVibrationEnabled();
      _addStatus(
          vibrationEnabled ? "📳 Vibration enabled" : "📱 Vibration disabled");

      // 5. Test instant notification
      _addStatus("📤 Testing instant notification...");
      await _notifyHelper.displayNotification(
        id: 9999,
        title: "✅ Notification Test",
        body: "If you see this, notifications are working perfectly!",
        payload: "test_notification",
      );
      _addStatus("✅ Instant notification sent");

      // 6. Test task notification
      _addStatus("📋 Testing task notification...");
      final testTask = Task(
        id: 9998,
        title: "Test Task Notification",
        description: "This is a test task notification",
        startTime: "12:00 PM",
        repeat: "Once",
        date: DateTime.now().toString(),
        remind: 5,
        isCompleted: 0,
      );

      await _notifyHelper.scheduledNotification(
        DateTime.now().hour,
        DateTime.now().minute + 1, // Schedule for 1 minute from now
        testTask,
      );
      _addStatus("✅ Task notification scheduled for 1 minute from now");

      // 7. Test daily notification
      _addStatus("📅 Testing daily notification capability...");
      await _notifyHelper.scheduleDailyNotification(
        id: 9997,
        title: "Daily Test Reminder",
        body: "This is a daily notification test",
        hour: 9,
        minute: 0,
      );
      _addStatus("✅ Daily notification capability verified");

      _addStatus("🎉 All notification checks completed successfully!");
    } catch (e) {
      _addStatus("❌ Error during notification check: $e");
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _addStatus(String status) {
    setState(() {
      _statusChecks.add(status);
    });
    // Add a small delay for visual effect
    Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Notification Status Check'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isChecking
                              ? Icons.hourglass_top
                              : Icons.check_circle,
                          color: _isChecking ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isChecking ? 'Running Checks...' : 'Check Complete',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    if (!_isChecking && _statusChecks.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Total checks: ${_statusChecks.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _statusChecks.length + (_isChecking ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _statusChecks.length && _isChecking) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Checking...'),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        _statusChecks[index],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: _statusChecks[index].startsWith('❌')
                              ? Colors.red
                              : _statusChecks[index].startsWith('⚠️')
                                  ? Colors.orange
                                  : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _performNotificationCheck,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Re-run Check'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
