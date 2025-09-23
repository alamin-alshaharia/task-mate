import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/notification_services.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotifyHelper _notifyHelper = NotifyHelper();

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _weeklyReportTime = const TimeOfDay(hour: 18, minute: 0);
  int _weeklyReportDay = 7; // Sunday

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationsEnabled = await _notifyHelper.areNotificationsEnabled();
    final soundEnabled = await _notifyHelper.isSoundEnabled();
    final vibrationEnabled = await _notifyHelper.isVibrationEnabled();

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _soundEnabled = soundEnabled;
      _vibrationEnabled = vibrationEnabled;
    });
  }

  Future<void> _testNotification() async {
    await _notifyHelper.displayNotification(
      id: 0,
      title: "🧪 Test Notification",
      body: "This is how your notifications will look! 🚀",
      payload: "test",
    );

    Get.snackbar(
      "Test Sent! 📤",
      "Check your notification panel",
      backgroundColor: context.theme.colorScheme.primaryContainer,
      colorText: context.theme.colorScheme.onPrimaryContainer,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _sendMotivationalNotification() async {
    await _notifyHelper.showMotivationalNotification();
    Get.snackbar(
      "Motivation Sent! 💪",
      "Hope it inspires you!",
      backgroundColor: context.theme.colorScheme.secondaryContainer,
      colorText: context.theme.colorScheme.onSecondaryContainer,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _scheduleDaily() async {
    await _notifyHelper.scheduleDailyNotification(
      id: 1001,
      title: "Daily Task Review",
      body: "📋 Time to review your tasks and plan your day!",
      hour: _dailyReminderTime.hour,
      minute: _dailyReminderTime.minute,
    );

    Get.snackbar(
      "Daily Reminder Set! ⏰",
      "You'll get reminded at ${_dailyReminderTime.format(context)}",
      backgroundColor: context.theme.colorScheme.primaryContainer,
      colorText: context.theme.colorScheme.onPrimaryContainer,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _scheduleWeekly() async {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    await _notifyHelper.scheduleWeeklyNotification(
      id: 1002,
      title: "Weekly Progress Report",
      body: "📊 Time to review your weekly accomplishments and set new goals!",
      weekday: _weeklyReportDay,
      hour: _weeklyReportTime.hour,
      minute: _weeklyReportTime.minute,
    );

    Get.snackbar(
      "Weekly Report Set! 📊",
      "You'll get your report every ${weekdays[_weeklyReportDay - 1]} at ${_weeklyReportTime.format(context)}",
      backgroundColor: context.theme.colorScheme.tertiaryContainer,
      colorText: context.theme.colorScheme.onTertiaryContainer,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _showPendingNotifications() async {
    final pending = await _notifyHelper.getPendingNotifications();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📅 Pending Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: pending.isEmpty
              ? const Text('No pending notifications')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: pending.length,
                  itemBuilder: (context, index) {
                    final notification = pending[index];
                    return ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(notification.title ?? 'No title'),
                      subtitle: Text(notification.body ?? 'No body'),
                      trailing: Text('ID: ${notification.id}'),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Notification Settings'),
        elevation: 0,
        backgroundColor: context.theme.colorScheme.surface,
        foregroundColor: context.theme.colorScheme.onSurface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚙️ General Settings',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle:
                        const Text('Allow TaskMate to send notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      await _notifyHelper.setNotificationsEnabled(value);
                      setState(() => _notificationsEnabled = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Sound'),
                    subtitle: const Text('Play sound with notifications'),
                    value: _soundEnabled,
                    onChanged: _notificationsEnabled
                        ? (value) async {
                            await _notifyHelper.setSoundEnabled(value);
                            setState(() => _soundEnabled = value);
                          }
                        : null,
                  ),
                  SwitchListTile(
                    title: const Text('Vibration'),
                    subtitle: const Text('Vibrate with notifications'),
                    value: _vibrationEnabled,
                    onChanged: _notificationsEnabled
                        ? (value) async {
                            await _notifyHelper.setVibrationEnabled(value);
                            setState(() => _vibrationEnabled = value);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Scheduled Notifications Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⏰ Scheduled Reminders',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: const Text('Daily Task Review'),
                    subtitle: Text(
                        'Reminder at ${_dailyReminderTime.format(context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _dailyReminderTime,
                        );
                        if (time != null) {
                          setState(() => _dailyReminderTime = time);
                        }
                      },
                    ),
                    onTap: _scheduleDaily,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_view_week),
                    title: const Text('Weekly Progress Report'),
                    subtitle: Text('${[
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday'
                    ][_weeklyReportDay - 1]} at ${_weeklyReportTime.format(context)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<int>(
                          value: _weeklyReportDay,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Mon')),
                            DropdownMenuItem(value: 2, child: Text('Tue')),
                            DropdownMenuItem(value: 3, child: Text('Wed')),
                            DropdownMenuItem(value: 4, child: Text('Thu')),
                            DropdownMenuItem(value: 5, child: Text('Fri')),
                            DropdownMenuItem(value: 6, child: Text('Sat')),
                            DropdownMenuItem(value: 7, child: Text('Sun')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _weeklyReportDay = value);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _weeklyReportTime,
                            );
                            if (time != null) {
                              setState(() => _weeklyReportTime = time);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: _scheduleWeekly,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚀 Quick Actions',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _testNotification,
                          icon: const Icon(Icons.science),
                          label: const Text('Test Notification'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _sendMotivationalNotification,
                          icon: const Icon(Icons.psychology),
                          label: const Text('Get Motivated'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showPendingNotifications,
                          icon: const Icon(Icons.schedule),
                          label: const Text('View Pending'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _notifyHelper.cancelAllNotifications();
                            Get.snackbar(
                              "Cleared! 🧹",
                              "All notifications cancelled",
                              backgroundColor:
                                  context.theme.colorScheme.errorContainer,
                              colorText:
                                  context.theme.colorScheme.onErrorContainer,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                            );
                          },
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info Card
          Card(
            color: context.theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About Notifications',
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Task reminders help you stay on track\n'
                    '• Daily reviews keep you organized\n'
                    '• Weekly reports show your progress\n'
                    '• Motivational messages boost productivity\n'
                    '• All notifications respect your preferences',
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
