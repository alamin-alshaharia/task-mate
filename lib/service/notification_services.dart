import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  static final NotifyHelper _instance = NotifyHelper._internal();
  factory NotifyHelper() => _instance;
  NotifyHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification channels
  static const String taskChannelId = 'task_notifications';
  static const String taskChannelName = 'Task Reminders';
  static const String dailyChannelId = 'daily_notifications';
  static const String dailyChannelName = 'Daily Reminders';
  static const String weeklyChannelId = 'weekly_notifications';
  static const String weeklyChannelName = 'Weekly Reminders';

  // Preferences keys
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String soundEnabledKey = 'notification_sound_enabled';
  static const String vibrationEnabledKey = 'notification_vibration_enabled';

  bool _isInitialized = false;

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await initializeNotificationWithoutPermissions();
    }
  }

  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    try {
      await _configureLocalTimeZone();

      // Enhanced iOS settings with proper permissions
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        requestCriticalPermission: false,
        requestProvisionalPermission: false,
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            _handleBackgroundNotificationResponse,
      );

      await _requestNotificationPermissions();
      await _createNotificationChannels();

      _isInitialized = true;
      debugPrint('✅ Notification system initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
      rethrow;
    }
  }

  /// Initialize notification system without requesting permissions immediately
  /// This avoids showing permission dialogs on app startup
  Future<void> initializeNotificationWithoutPermissions() async {
    if (_isInitialized) {
      debugPrint('ℹ️ Notification system already initialized');
      return;
    }

    try {
      await _configureLocalTimeZone();

      // Enhanced iOS settings with minimal permissions request
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        requestCriticalPermission: false,
        requestProvisionalPermission: false,
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            _handleBackgroundNotificationResponse,
      );

      // Only create channels, don't request permissions
      await _createNotificationChannels();

      _isInitialized = true;
      debugPrint('✅ Notification system initialized (without permissions)');
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
      rethrow;
    }
  }

  /// Request notification permissions when actually needed
  Future<bool> requestNotificationPermissions() async {
    return await _requestNotificationPermissions();
  }

  /// Check if notification permissions are already granted
  Future<bool> hasNotificationPermissions() async {
    bool hasPermissions = false;

    if (GetPlatform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        hasPermissions = await androidPlugin.areNotificationsEnabled() ?? false;
      }
    }

    if (GetPlatform.isIOS) {
      final iosPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        final settings = await iosPlugin.checkPermissions();
        hasPermissions = settings?.isEnabled ?? false;
      }
    }

    return hasPermissions;
  }

  /// Request exact alarm permissions for scheduling notifications on Android 12+
  Future<bool> requestExactAlarmPermissions() async {
    if (GetPlatform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        try {
          await androidPlugin.requestExactAlarmsPermission();
          debugPrint('ℹ️ Exact alarm permission requested');
          return true;
        } catch (e) {
          debugPrint('⚠️ Error requesting exact alarm permission: $e');
          return false;
        }
      }
    }
    return true; // iOS doesn't need this permission
  }

  @pragma('vm:entry-point')
  static void _handleBackgroundNotificationResponse(
      NotificationResponse response) {
    debugPrint('Background notification received: ${response.payload}');
  }

  Future<void> _createNotificationChannels() async {
    // Create notification channels for Android
    const AndroidNotificationChannel taskChannel = AndroidNotificationChannel(
      taskChannelId,
      taskChannelName,
      description: 'Notifications for individual task reminders',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    const AndroidNotificationChannel dailyChannel = AndroidNotificationChannel(
      dailyChannelId,
      dailyChannelName,
      description: 'Notifications for daily recurring tasks',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    const AndroidNotificationChannel weeklyChannel = AndroidNotificationChannel(
      weeklyChannelId,
      weeklyChannelName,
      description: 'Notifications for weekly recurring tasks',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final plugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (plugin != null) {
      await plugin.createNotificationChannel(taskChannel);
      await plugin.createNotificationChannel(dailyChannel);
      await plugin.createNotificationChannel(weeklyChannel);
    }
  }

  Future<bool> _requestNotificationPermissions() async {
    bool granted = false;

    if (GetPlatform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        granted = await androidPlugin.requestNotificationsPermission() ?? false;

        // Only request exact alarm permission if notifications are granted
        // and when actually scheduling notifications
        if (granted) {
          debugPrint('ℹ️ Basic notification permission granted');
        }
      }
    }

    if (GetPlatform.isIOS) {
      final iosPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        granted = await iosPlugin.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
              critical: false,
              provisional: false,
            ) ??
            false;
      }
    }

    debugPrint('Notification permissions granted: $granted');
    return granted;
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsEnabledKey, enabled);
  }

  Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(soundEnabledKey, enabled);
  }

  Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(vibrationEnabledKey, enabled);
  }

  void _handleNotificationResponse(NotificationResponse notificationResponse) {
    debugPrint('📱 Notification tapped: ${notificationResponse.payload}');

    if (notificationResponse.payload != null) {
      try {
        // Parse the payload to extract task information
        final payload = notificationResponse.payload!;

        if (payload.startsWith('task_')) {
          final taskId = payload.replaceFirst('task_', '');
          _navigateToTaskDetails(taskId);
        } else {
          // General navigation
          _navigateToCalendar();
        }
      } catch (e) {
        debugPrint('Error handling notification response: $e');
        _navigateToCalendar();
      }
    }
  }

  void _navigateToTaskDetails(String taskId) {
    // Navigate to home or calendar based on app state
    try {
      // Since we can't import specific pages here to avoid circular imports,
      // we'll use a more generic approach
      debugPrint('📍 Should navigate to task: $taskId');
      // The actual navigation will be handled by the app's routing system
    } catch (e) {
      debugPrint('Error handling task navigation: $e');
    }
  }

  void _navigateToCalendar() {
    try {
      debugPrint('📍 Should navigate to calendar page');
      // The actual navigation will be handled by the app's routing system
    } catch (e) {
      debugPrint('Error handling calendar navigation: $e');
    }
  }

  Future<void> displayNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? icon,
    Color? color,
  }) async {
    await ensureInitialized();

    if (!await areNotificationsEnabled()) {
      debugPrint('⚠️ Notifications are disabled by user');
      return;
    }

    // Request permissions when actually trying to show a notification
    final hasPermissions = await _requestNotificationPermissions();
    if (!hasPermissions) {
      debugPrint('⚠️ Notification permissions not granted');
      return;
    }

    try {
      final soundEnabled = await isSoundEnabled();
      final vibrationEnabled = await isVibrationEnabled();

      final androidDetails = AndroidNotificationDetails(
        taskChannelId,
        taskChannelName,
        channelDescription: 'Task reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        icon: icon ?? '@mipmap/ic_launcher',
        color: color,
        ticker: 'TaskMate: $title',
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: false,
          contentTitle: title,
          htmlFormatContentTitle: false,
        ),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'TaskMate Reminder',
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformDetails,
        payload: payload ?? 'general_notification',
      );

      debugPrint('✅ Notification displayed: $title');
    } catch (e) {
      debugPrint('❌ Error displaying notification: $e');
    }
  }

  /// Schedule a notification for a specific DateTime (for immediate/short-term scheduling)
  Future<void> scheduleNotificationAt(DateTime scheduleTime, Task task) async {
    debugPrint(
        '🔔 Scheduling immediate notification for task: ${task.title} at $scheduleTime');

    // Validate task data
    if (task.id == null) {
      debugPrint('❌ Cannot schedule notification: Task ID is null');
      return;
    }

    await ensureInitialized();

    if (!await areNotificationsEnabled()) {
      debugPrint('⚠️ Notifications disabled, skipping task: ${task.title}');
      return;
    }

    // Request permissions when actually trying to schedule a notification
    final hasPermissions = await _requestNotificationPermissions();
    if (!hasPermissions) {
      debugPrint(
          '⚠️ Notification permissions not granted, skipping task: ${task.title}');
      return;
    }

    // Request exact alarm permissions for scheduling
    await requestExactAlarmPermissions();

    try {
      final soundEnabled = await isSoundEnabled();
      final vibrationEnabled = await isVibrationEnabled();

      // Convert DateTime to TZDateTime
      final tz.TZDateTime tzScheduleTime =
          tz.TZDateTime.from(scheduleTime, tz.local);

      debugPrint(
          '📅 Schedule time calculated: $tzScheduleTime (now: ${tz.TZDateTime.now(tz.local)})');

      final androidDetails = AndroidNotificationDetails(
        taskChannelId,
        taskChannelName,
        channelDescription: 'Individual task reminders',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        icon: '@mipmap/ic_launcher',
        ticker: 'TaskMate: ${task.title}',
        styleInformation: BigTextStyleInformation(
          '⏰ ${task.description ?? "Task reminder"}',
          htmlFormatBigText: false,
          contentTitle: '📋 ${task.title ?? "Task Reminder"}',
          htmlFormatContentTitle: false,
        ),
        actions: [
          const AndroidNotificationAction(
            'mark_done',
            'Mark Done ✅',
            showsUserInterface: false,
          ),
          const AndroidNotificationAction(
            'snooze',
            'Snooze 10min ⏰',
            showsUserInterface: false,
          ),
        ],
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'Task Reminder',
        categoryIdentifier: 'task_reminder',
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        '📋 ${task.title ?? "Task Reminder"}',
        '⏰ ${task.description ?? "Task reminder"}',
        tzScheduleTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'task_${task.id}',
      );

      final secondsUntil =
          tzScheduleTime.difference(tz.TZDateTime.now(tz.local)).inSeconds;
      debugPrint(
          '✅ Scheduled immediate notification for "${task.title ?? "Task"}" at $tzScheduleTime (in ${secondsUntil}s)');
    } catch (e) {
      debugPrint(
          '❌ Error scheduling immediate notification for task ${task.id}: $e');
    }
  }

  Future<void> scheduledNotification(int hour, int minute, Task task) async {
    debugPrint(
        '🔔 Scheduling notification for task: ${task.title} at $hour:$minute');

    // Validate task data
    if (task.id == null) {
      debugPrint('❌ Cannot schedule notification: Task ID is null');
      return;
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      debugPrint('❌ Invalid time format: $hour:$minute');
      return;
    }

    await ensureInitialized();

    if (!await areNotificationsEnabled()) {
      debugPrint('⚠️ Notifications disabled, skipping task: ${task.title}');
      return;
    }

    // Request permissions when actually trying to schedule a notification
    final hasPermissions = await _requestNotificationPermissions();
    if (!hasPermissions) {
      debugPrint(
          '⚠️ Notification permissions not granted, skipping task: ${task.title}');
      return;
    }

    // Request exact alarm permissions for scheduling
    await requestExactAlarmPermissions();

    try {
      final soundEnabled = await isSoundEnabled();
      final vibrationEnabled = await isVibrationEnabled();
      final scheduleTime = _convertTime(hour, minute);

      debugPrint(
          '📅 Schedule time calculated: $scheduleTime (now: ${tz.TZDateTime.now(tz.local)})');

      final androidDetails = AndroidNotificationDetails(
        taskChannelId,
        taskChannelName,
        channelDescription: 'Individual task reminders',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        icon: '@mipmap/ic_launcher',
        ticker: 'TaskMate: ${task.title}',
        styleInformation: BigTextStyleInformation(
          '⏰ ${task.description ?? "Task reminder"}',
          htmlFormatBigText: false,
          contentTitle: '📋 ${task.title ?? "Task Reminder"}',
          htmlFormatContentTitle: false,
        ),
        actions: [
          const AndroidNotificationAction(
            'mark_done',
            'Mark Done ✅',
            showsUserInterface: false,
          ),
          const AndroidNotificationAction(
            'snooze',
            'Snooze 10min ⏰',
            showsUserInterface: false,
          ),
        ],
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'Task Reminder',
        categoryIdentifier: 'task_reminder',
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Determine the repeat pattern based on task settings
      final bool isRepeating = task.repeat != null &&
          task.repeat!.toLowerCase() != 'once' &&
          task.repeat!.toLowerCase() != 'never';

      DateTimeComponents? matchComponents;
      if (isRepeating) {
        if (task.repeat!.toLowerCase() == 'daily') {
          matchComponents = DateTimeComponents.time;
        } else if (task.repeat!.toLowerCase() == 'weekly') {
          matchComponents = DateTimeComponents.dayOfWeekAndTime;
        }
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        '📋 ${task.title ?? "Task Reminder"}',
        '⏰ ${task.description ?? "Task reminder"}',
        scheduleTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            matchComponents, // Only repeat if task is recurring
        payload: 'task_${task.id}',
      );

      debugPrint(
          '📋 Notification type: ${isRepeating ? "Recurring (${task.repeat})" : "One-time"}');

      debugPrint(
          '✅ Scheduled notification for "${task.title ?? "Task"}" at ${scheduleTime.toString().split(' ')[1]}');
    } catch (e) {
      debugPrint('❌ Error scheduling notification for task ${task.id}: $e');
    }
  }

  Future<void> selectNotification(String? payload) async {
    debugPrint('notification payload: $payload');
  }

  tz.TZDateTime _convertTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    debugPrint('⏰ Time conversion details:');
    debugPrint('   Input: $hour:${minute.toString().padLeft(2, '0')}');
    debugPrint('   Current time: $now');
    debugPrint('   Initial schedule: $scheduleDate');

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
      debugPrint('   ⏭️ Moved to next day: $scheduleDate');
    }

    final minutesUntil = scheduleDate.difference(now).inMinutes;
    debugPrint('   ⏱️ Notification will trigger in $minutesUntil minutes');

    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    try {
      // Try to use system timezone, fallback to UTC if not available
      final String timeZoneName = DateTime.now().timeZoneName;
      final String timeZoneOffset = DateTime.now().timeZoneOffset.toString();

      debugPrint('🌍 System timezone: $timeZoneName (offset: $timeZoneOffset)');

      // Try to find a matching timezone location
      try {
        // Common timezone mappings - you can extend this list
        String locationName = 'UTC';

        // For Bangladesh/Dhaka timezone (GMT+6)
        if (timeZoneOffset.contains('6:00:00')) {
          locationName = 'Asia/Dhaka';
        }
        // For US Eastern (GMT-5/-4)
        else if (timeZoneOffset.contains('-5:00:00') ||
            timeZoneOffset.contains('-4:00:00')) {
          locationName = 'America/New_York';
        }
        // For US Pacific (GMT-8/-7)
        else if (timeZoneOffset.contains('-8:00:00') ||
            timeZoneOffset.contains('-7:00:00')) {
          locationName = 'America/Los_Angeles';
        }
        // For Europe/London (GMT+0/+1)
        else if (timeZoneOffset.contains('0:00:00') ||
            timeZoneOffset.contains('1:00:00')) {
          locationName = 'Europe/London';
        }
        // Add more timezone mappings as needed

        tz.setLocalLocation(tz.getLocation(locationName));
        debugPrint('✅ Timezone set to: $locationName');
      } catch (e) {
        debugPrint('⚠️ Could not set specific timezone, using UTC: $e');
        tz.setLocalLocation(tz.UTC);
      }

      debugPrint('📍 Final local time: ${tz.TZDateTime.now(tz.local)}');
    } catch (e) {
      debugPrint('❌ Error configuring timezone: $e');
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Schedule a daily recurring notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await ensureInitialized();

    if (!await areNotificationsEnabled()) {
      debugPrint('⚠️ Daily notifications disabled');
      return;
    }

    try {
      final soundEnabled = await isSoundEnabled();
      final vibrationEnabled = await isVibrationEnabled();

      final androidDetails = AndroidNotificationDetails(
        dailyChannelId,
        dailyChannelName,
        channelDescription: 'Daily reminders and motivational messages',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        icon: '@mipmap/ic_launcher',
        ticker: 'TaskMate: Daily Reminder',
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: false,
          contentTitle: '🌟 $title',
          htmlFormatContentTitle: false,
        ),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'Daily Reminder',
        categoryIdentifier: 'daily_reminder',
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        '🌟 $title',
        body,
        _convertTime(hour, minute),
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      debugPrint('✅ Scheduled daily notification "$title" at $hour:$minute');
    } catch (e) {
      debugPrint('❌ Error scheduling daily notification: $e');
    }
  }

  /// Schedule a weekly recurring notification
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday, // 1-7 (Monday-Sunday)
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await ensureInitialized();

    if (!await areNotificationsEnabled()) {
      debugPrint('⚠️ Weekly notifications disabled');
      return;
    }

    try {
      final soundEnabled = await isSoundEnabled();
      final vibrationEnabled = await isVibrationEnabled();

      final androidDetails = AndroidNotificationDetails(
        weeklyChannelId,
        weeklyChannelName,
        channelDescription: 'Weekly progress reports and summaries',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        icon: '@mipmap/ic_launcher',
        ticker: 'TaskMate: Weekly Report',
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: false,
          contentTitle: '📊 $title',
          htmlFormatContentTitle: false,
        ),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: 'Weekly Report',
        categoryIdentifier: 'weekly_report',
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final now = tz.TZDateTime.now(tz.local);
      final daysUntilWeekday = (weekday - now.weekday) % 7;
      final nextWeekday =
          now.add(Duration(days: daysUntilWeekday == 0 ? 7 : daysUntilWeekday));
      final scheduleTime = tz.TZDateTime(tz.local, nextWeekday.year,
          nextWeekday.month, nextWeekday.day, hour, minute);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        '📊 $title',
        body,
        scheduleTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );

      debugPrint(
          '✅ Scheduled weekly notification "$title" for weekday $weekday at $hour:$minute');
    } catch (e) {
      debugPrint('❌ Error scheduling weekly notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      debugPrint('✅ Cancelled notification with ID: $id');
    } catch (e) {
      debugPrint('❌ Error cancelling notification $id: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('✅ Cancelled all notifications');
    } catch (e) {
      debugPrint('❌ Error cancelling all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
    } catch (e) {
      debugPrint('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  /// Display motivational notification
  Future<void> showMotivationalNotification() async {
    final motivationalMessages = [
      "🎯 You've got this! Time to tackle your tasks!",
      "💪 Small steps lead to big achievements!",
      "⭐ Your productivity journey starts now!",
      "🚀 Ready to make today amazing?",
      "🌟 Every task completed is progress made!",
      "🎉 You're closer to your goals than yesterday!",
    ];

    final random =
        DateTime.now().millisecondsSinceEpoch % motivationalMessages.length;
    final message = motivationalMessages[random];

    await displayNotification(
      id: 999,
      title: "TaskMate Motivation",
      body: message,
      payload: "motivation",
    );
  }

  /// Legacy method - kept for backward compatibility
  @Deprecated('Use scheduleDailyNotification instead')
  Future<void> createDailyReminder(int hour, int minute, Task task) async {
    await scheduleDailyNotification(
      id: task.id!.toInt(),
      title: task.title ?? 'Task Reminder',
      body: task.description ?? 'Task reminder',
      hour: hour,
      minute: minute,
      payload: 'task_${task.id}',
    );
  }

  /// Legacy method - kept for backward compatibility
  @Deprecated('Use scheduleWeeklyNotification instead')
  Future<void> scheduledWeeklyNotification(
      int hour, int minute, Task task) async {
    await scheduleWeeklyNotification(
      id: task.id!.toInt(),
      title: task.title ?? 'Weekly Task Reminder',
      body: task.description ?? 'Weekly task reminder',
      weekday: DateTime.now().weekday,
      hour: hour,
      minute: minute,
      payload: 'task_${task.id}',
    );
  }
}
