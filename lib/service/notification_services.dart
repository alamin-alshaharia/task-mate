// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // // import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// // import 'package:flutter_task_planner_app/screens/calendar_page.dart';
// // import 'package:get/get.dart';
// // import 'package:timezone/data/latest.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:flutter_task_planner_app/model/task_model.dart';
// //
// // class NotifyHelper {
// //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //   static Future<void> onDidReceiveBackgroundNotificationResponse(
// //       NotificationResponse notificationResponce) async {}
// //   get selectNotificationSubject => null;
// //   Set<int> notifiedTasks = {};
// //
// //   initializeNotification() async {
// //     _configureLocalTimeZone();
// //     tz.initializeTimeZones();
// //     final DarwinInitializationSettings initializationSettingsIOS =
// //         DarwinInitializationSettings(
// //       requestSoundPermission: false,
// //       requestBadgePermission: false,
// //       requestAlertPermission: false,
// //       // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
// //     );
// //     Future<void> _onDidReceiveLocalNotification(
// //         int id, String? title, String? body, String? payload) async {
// //       // Handle the notification here
// //     }
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //     //initialize the ios settings
// //     const DarwinInitializationSettings initializationSettingsIos =
// //         DarwinInitializationSettings();
// //     //combine the android and ios settings
// //     const InitializationSettings initializationSettings =
// //         InitializationSettings(
// //       android: initializationSettingsAndroid,
// //       iOS: initializationSettingsIos,
// //     );
// //     //initialize the plugin
// //     await flutterLocalNotificationsPlugin.initialize(
// //       initializationSettings,
// //       onDidReceiveBackgroundNotificationResponse:
// //           onDidReceiveBackgroundNotificationResponse,
// //       onDidReceiveNotificationResponse:
// //           onDidReceiveBackgroundNotificationResponse,
// //     );
// //
// //     // Handle local notification received while the app is in the foreground
// //
// //     //request permission to show notifications andriod
// //     await flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()
// //         ?.requestNotificationsPermission();
// //     //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //     //       onSelectNotification: selectNotification);
// //   }
// //
// //   // Just show the source code of onSelectNotification(flutter_local_notifications: ^9.9.0 )
// //   // Future onSelectNotification (String? payload) async {
// //   //   if (payload != null) {
// //   //     debugPrint('notification payload: $payload');
// //   //   }
// //   //   selectNotificationSubject.add(payload);
// //   // }
// //
// //   Future<void> displayNotification(
// //       {required String title, required String body}) async {
// //     print("doing test");
// //     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
// //       'your channel id',
// //       'your channel name',
// //       channelDescription: 'your channel description',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //     );
// //     var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
// //     var platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics,
// //         iOS: iOSPlatformChannelSpecifics);
// //     // var platformChannelSpecifics = NotificationDetails(
// //     //     android: androidPlatformChannelSpecifics);
// //     await flutterLocalNotificationsPlugin.show(
// //       0,
// //       title,
// //       body,
// //       platformChannelSpecifics,
// //       payload: title,
// //     );
// //   }
// //
// //   // single reminder
// //   scheduledNotification(int hour, int minute, Task task) async {
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       task.id!.toInt(),
// //       task.title,
// //       task.description,
// //       _convertTime(hour, minute),
// //       // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
// //       const NotificationDetails(
// //           android: AndroidNotificationDetails(
// //               'your channel id', 'your channel name')),
// //       androidAllowWhileIdle: true,
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       matchDateTimeComponents: DateTimeComponents.time,
// //       payload: "Task: ${task.title}\nNote: ${task.description}",
// //     );
// //   }
// //
// //   Future<void> createDailyReminder(int hour, int minute, Task task) async {
// //     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
// //         'your channel id', 'your channel name',
// //         channelDescription: 'your channel description',
// //         importance: Importance.max,
// //         priority: Priority.high);
// //     var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
// //     var platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics,
// //         iOS: iOSPlatformChannelSpecifics);
// //
// //     var now = tz.TZDateTime.now(tz.local);
// //
// //     var scheduledDate =
// //         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
// //     if (scheduledDate.isBefore(now)) {
// //       // if the time is after today 7pm, then pass to next day 7pm
// //       scheduledDate = scheduledDate.add(const Duration(days: 1));
// //     }
// //
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       task.id!.toInt(),
// //       task.title,
// //       task.description,
// //       scheduledDate,
// //       platformChannelSpecifics,
// //       payload: "Task: ${task.title}\nNote: ${task.description}",
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       matchDateTimeComponents: DateTimeComponents.time,
// //       androidAllowWhileIdle: true,
// //     );
// //   }
// //
// //   void showCustomNotificationDialog(String? title, String? note, Task task) {
// //     showDialog(
// //       context: Get.overlayContext!,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           backgroundColor: Colors.transparent,
// //           child: Container(
// //             margin: EdgeInsets.only(top: 24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.3),
// //                   spreadRadius: 4,
// //                   blurRadius: 10,
// //                   offset: Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue,
// //                     borderRadius: BorderRadius.only(
// //                       topLeft: Radius.circular(16),
// //                       topRight: Radius.circular(16),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.notification_important, color: Colors.white),
// //                       SizedBox(width: 8),
// //                       Text(
// //                         title!,
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: EdgeInsets.all(16),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         'Note:',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Text(note!),
// //                       SizedBox(height: 16),
// //                       ElevatedButton(
// //                         child: Text('OK'),
// //                         onPressed: () {
// //                           Get.back();
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   tz.TZDateTime _convertTime(int hour, int minutes) {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// //     tz.TZDateTime scheduleDate =
// //         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
// //     if (scheduleDate.isBefore(now)) {
// //       scheduleDate = scheduleDate.add(const Duration(days: 1));
// //     }
// //     return scheduleDate;
// //   }
// //
// //   // TODO ---- Something wrong in this function(?Phone timezone setting?)
// //   /* get local timezone */
// //   // Future<void> _configureLocalTimeZone() async {
// //   //   tz.initializeTimeZones();
// //   //   final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
// //   //   tz.setLocalLocation(tz.getLocation(timeZone));
// //   // }
// //   Future<void> _configureLocalTimeZone() async {
// //     tz.initializeTimeZones();
// //     // todo - change to local timezone?
// //     final String timeZone = 'Asia/Shanghai';
// //     tz.setLocalLocation(tz.getLocation(timeZone));
// //   }
// //
// //   void requestIOSPermissions() {
// //     flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             IOSFlutterLocalNotificationsPlugin>()
// //         ?.requestPermissions(
// //           alert: true,
// //           badge: true,
// //           sound: true,
// //         );
// //   }
// //
// //   Future selectNotification(String? payload) async {
// //     if (payload != null) {
// //       print('notification payload: $payload');
// //     } else {
// //       print("Notification Done");
// //     }
// //     if (payload == "Theme Changed") {
// //       print("Nothing navigate to");
// //     } else {
// //       // SENT TO A Calendar PAGE
// //       print('notification payload: $payload');
// //       Get.to(CalendarPage());
// //       // Get.to(() => NotifiedPage(label:payload));
// //     }
// //   }
// //
// //   Future onDidReceiveLocalNotification(
// //       int id, String? title, String? body, String? payload) async {
// //     // showDialog(
// //     //   context: Get.overlayContext!,
// //     //   builder: (BuildContext context) => AlertDialog(
// //     //     title: Image.asset('assets/svg/icon_clipboard.svg', width: 64, height: 64), // Add your app logo here
// //     //     content: Column(
// //     //       children: [
// //     //         Text(title!, style: TextStyle(fontWeight: FontWeight.bold)),
// //     //         SizedBox(height: 8),
// //     //         Text(body!),
// //     //       ],
// //     //     ),
// //     //     actions: [
// //     //       TextButton(
// //     //         child: Text('OK'),
// //     //         onPressed: () {
// //     //           Get.back();
// //     //         },
// //     //       ),
// //     //     ],
// //     //   ),
// //     // );
// //   }
// //
// //   Future<void> _cancelAllNotifications() async {
// //     await flutterLocalNotificationsPlugin.cancelAll();
// //   }
// //
// //   scheduledWeeklyNotification(int hour, int minute, Task task) async {
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       task.id!.toInt(),
// //       task.title,
// //       task.description,
// //       _convertTime(hour, minute),
// //       // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
// //       const NotificationDetails(
// //           android: AndroidNotificationDetails(
// //               'your channel id', 'your channel name')),
// //       androidAllowWhileIdle: true,
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // edit this
// //       // payload: "${task.title}|"+"${task.note}|"
// //       payload: "Task: ${task.title}\nNote: ${task.description}",
// //     );
// //   }
// //
// //   Future<void> repeatWeeklyNotification(int hour, int minute, Task task) async {
// //     const AndroidNotificationDetails androidNotificationDetails =
// //         AndroidNotificationDetails(
// //             'repeating channel id', 'repeating channel name',
// //             channelDescription: 'repeating description');
// //     const NotificationDetails notificationDetails =
// //         NotificationDetails(android: androidNotificationDetails);
// //     await flutterLocalNotificationsPlugin.periodicallyShow(
// //         task.id!.toInt(),
// //         task.title,
// //         task.description,
// //         RepeatInterval.weekly,
// //         notificationDetails,
// //         androidAllowWhileIdle: true);
// //   }
// //
// //   Future<void> _scheduleWeeklyTenAMNotification() async {
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //         0,
// //         'weekly scheduled notification title',
// //         'weekly scheduled notification body',
// //         _nextInstanceOfTenAM(),
// //         const NotificationDetails(
// //           android: AndroidNotificationDetails('weekly notification channel id',
// //               'weekly notification channel name',
// //               channelDescription: 'weekly notificationdescription'),
// //         ),
// //         androidAllowWhileIdle: true,
// //         uiLocalNotificationDateInterpretation:
// //             UILocalNotificationDateInterpretation.absoluteTime,
// //         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
// //   }
// //
// //   tz.TZDateTime _nextInstanceOfTenAM() {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// //     tz.TZDateTime scheduledDate =
// //         tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
// //     if (scheduledDate.isBefore(now)) {
// //       scheduledDate = scheduledDate.add(const Duration(days: 1));
// //     }
// //     return scheduledDate;
// //   }
// //
// //   tz.TZDateTime _nextInstanceOfTenAMLastYear() {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// //     return tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10);
// //   }
// // }
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_task_planner_app/screens/calendar_page.dart';
// // import 'package:get/get.dart';
// // import 'package:timezone/data/latest.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:flutter_task_planner_app/model/task_model.dart';
// //
// // class NotifyHelper {
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //
// //   Set<int> notifiedTasks = {};
// //
// //   NotifyHelper() {
// //     initializeNotification();
// //   }
// //
// //   Future<void> initializeNotification() async {
// //     try {
// //       // Configure timezone
// //       _configureLocalTimeZone();
// //
// //       // iOS Initialization Settings
// //       final DarwinInitializationSettings initializationSettingsIOS =
// //           DarwinInitializationSettings(
// //         requestSoundPermission: false,
// //         requestBadgePermission: false,
// //         requestAlertPermission: false,
// //         onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
// //       );
// //
// //       // Android Initialization Settings
// //       const AndroidInitializationSettings initializationSettingsAndroid =
// //           AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //       // Combined Initialization Settings
// //       final InitializationSettings initializationSettings =
// //           InitializationSettings(
// //         android: initializationSettingsAndroid,
// //         iOS: initializationSettingsIOS,
// //       );
// //
// //       // Initialize the plugin
// //       await flutterLocalNotificationsPlugin.initialize(
// //         initializationSettings,
// //         onDidReceiveNotificationResponse: _handleNotificationResponse,
// //       );
// //
// //       // Request notification permissions for Android
// //       await _requestNotificationPermissions();
// //     } catch (e) {
// //       print('Error initializing notifications: $e');
// //     }
// //   }
// //
// //   Future<void> _requestNotificationPermissions() async {
// //     if (GetPlatform.isAndroid) {
// //       await flutterLocalNotificationsPlugin
// //           .resolvePlatformSpecificImplementation<
// //               AndroidFlutterLocalNotificationsPlugin>()
// //           ?.requestNotificationsPermission();
// //     }
// //
// //     if (GetPlatform.isIOS) {
// //       await flutterLocalNotificationsPlugin
// //           .resolvePlatformSpecificImplementation<
// //               IOSFlutterLocalNotificationsPlugin>()
// //           ?.requestPermissions(
// //             alert: true,
// //             badge: true,
// //             sound: true,
// //           );
// //     }
// //   }
// //
// //   Future<void> _onDidReceiveLocalNotification(
// //       int id, String? title, String? body, String? payload) async {
// //     // Handle received notification on iOS
// //     if (Get.context != null) {
// //       showDialog(
// //         context: Get.context!,
// //         builder: (context) => AlertDialog(
// //           title: Text(title ?? 'Notification'),
// //           content: Text(body ?? ''),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Get.back(),
// //               child: Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// //
// //   void _handleNotificationResponse(NotificationResponse notificationResponse) {
// //     if (notificationResponse.payload != null) {
// //       selectNotification(notificationResponse.payload);
// //     }
// //   }
// //
// //   Future<void> displayNotification(
// //       {required String title, required String body}) async {
// //     try {
// //       var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
// //         'your channel id',
// //         'your channel name',
// //         importance: Importance.max,
// //         priority: Priority.high,
// //       );
// //
// //       var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
// //
// //       var platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics,
// //         iOS: iOSPlatformChannelSpecifics,
// //       );
// //
// //       await flutterLocalNotificationsPlugin.show(
// //         0,
// //         title,
// //         body,
// //         platformChannelSpecifics,
// //         payload: title,
// //       );
// //     } catch (e) {
// //       print('Error displaying notification: $e');
// //     }
// //   }
// //
// //   Future<void> scheduledNotification(int hour, int minute, Task task) async {
// //     try {
// //       await flutterLocalNotificationsPlugin.zonedSchedule(
// //         task.id!.toInt(),
// //         task.title,
// //         task.description,
// //         _convertTime(hour, minute),
// //         NotificationDetails(
// //           android: AndroidNotificationDetails(
// //             'task_channel_id',
// //             'Task Notifications',
// //             importance: Importance.max,
// //             priority: Priority.high,
// //           ),
// //         ),
// //         androidAllowWhileIdle: true,
// //         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //         uiLocalNotificationDateInterpretation:
// //             UILocalNotificationDateInterpretation.absoluteTime,
// //         matchDateTimeComponents: DateTimeComponents.time,
// //         payload: "Task: ${task.title}\nNote: ${task.description}",
// //       );
// //     } catch (e) {
// //       print('Error scheduling notification: $e');
// //     }
// //   }
// //
// //   Future<void> selectNotification(String? payload) async {
// //     if (payload != null) {
// //       debugPrint('Notification payload: $payload');
// //       Get.to(() => CalendarPage());
// //     }
// //   }
// //
// //   tz.TZDateTime _convertTime(int hour, int minutes) {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// //     tz.TZDateTime scheduleDate =
// //         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
// //
// //     return scheduleDate.isBefore(now)
// //         ? scheduleDate.add(const Duration(seconds: 10))
// //         : scheduleDate;
// //   }
// //
// //   Future<void> _configureLocalTimeZone() async {
// //     tz.initializeTimeZones();
// //     final String timeZone = tz.local.name;
// //     tz.setLocalLocation(tz.getLocation(timeZone));
// //   }
// //
// //   Future<void> cancelAllNotifications() async {
// //     await flutterLocalNotificationsPlugin.cancelAll();
// //   }
// // }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_task_planner_app/model/task_model.dart';
//
// class NotifyHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   NotifyHelper() {
//     initializeNotification();
//   }
//
//   Future<void> initializeNotification() async {
//     try {
//       // Configure timezone
//       await _configureLocalTimeZone();
//
//       // iOS Initialization Settings
//       final DarwinInitializationSettings initializationSettingsIOS =
//           DarwinInitializationSettings(
//         requestSoundPermission: false,
//         requestBadgePermission: false,
//         requestAlertPermission: false,
//         // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//       );
//
//       // Android Initialization Settings
//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('@mipmap/ic_launcher');
//
//       // Combined Initialization Settings
//       final InitializationSettings initializationSettings =
//           InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//       );
//
//       // Initialize the plugin
//       await flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: _handleNotificationResponse,
//       );
//
//       // Request notification permissions for Android and iOS
//       await _requestNotificationPermissions();
//     } catch (e) {
//       debugPrint('Error initializing notifications: $e');
//     }
//   }
//
//   Future<void> _requestNotificationPermissions() async {
//     if (GetPlatform.isAndroid) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//     }
//
//     if (GetPlatform.isIOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//     }
//   }
//
//   Future<void> _onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     if (Get.context != null) {
//       showDialog(
//         context: Get.context!,
//         builder: (context) => AlertDialog(
//           title: Text(title ?? 'Notification'),
//           content: Text(body ?? ''),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   void _handleNotificationResponse(NotificationResponse notificationResponse) {
//     if (notificationResponse.payload != null) {
//       selectNotification(notificationResponse.payload);
//     }
//   }
//
//   Future<void> displayNotification({
//     required String title,
//     required String body,
//   }) async {
//     try {
//       var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         'your_channel_id',
//         'your_channel_name',
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//
//       var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
//
//       var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics,
//       );
//
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         body,
//         platformChannelSpecifics,
//         payload: title,
//       );
//     } catch (e) {
//       debugPrint('Error displaying notification: $e');
//     }
//   }
//
//   Future<void> scheduledNotification(int hour, int minute, Task task) async {
//     try {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!.toInt(),
//         task.title,
//         task.description,
//         _convertTime(hour, minute),
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'task_channel_id',
//             'Task Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//         // androidAllowWhileIdle: true,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//         payload: "Task: ${task.title}\nNote: ${task.description}",
//       );
//     } catch (e) {
//       debugPrint('Error scheduling notification: $e');
//     }
//   }
//
//   Future<void> createDailyReminder(int hour, int minute, Task task) async {
//     try {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!.toInt(),
//         task.title,
//         task.description,
//         _getNextInstanceOfTime(hour, minute),
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'daily_reminder_channel',
//             'Daily Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//         // androidAllowWhileIdle: true,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//         payload: "Daily Reminder: ${task.title}\nNote: ${task.description}",
//       );
//     } catch (e) {
//       debugPrint('Error creating daily reminder: $e');
//     }
//   }
//
//   Future<void> scheduledWeeklyNotification(
//       int hour, int minute, Task task) async {
//     try {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!.toInt(),
//         task.title,
//         task.description,
//         _getNextInstanceOfWeek(hour, minute),
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'weekly_reminder_channel',
//             'Weekly Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//         // androidAllowWhileIdle: true,
//
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//         payload: "Weekly Reminder: ${task.title}\nNote: ${task.description}",
//       );
//     } catch (e) {
//       debugPrint('Error scheduling weekly notification: $e');
//     }
//   }
//
//   Future<void> selectNotification(String? payload) async {
//     if (payload != null) {
//       debugPrint('Notification payload: $payload');
//       // Navigate to the desired page based on the payload
//       // Example: Get.to(() => TaskDetailPage(payload: payload));
//     }
//   }
//
//   tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
//
//     return scheduleDate.isBefore(now)
//         ? scheduleDate.add(const Duration(days: 1))
//         : scheduleDate;
//   }
//
//   tz.TZDateTime _getNextInstanceOfTime(int hour, int minute) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//
//     return scheduleDate.isBefore(now)
//         ? scheduleDate.add(const Duration(days: 1))
//         : scheduleDate;
//   }
//
//   tz.TZDateTime _getNextInstanceOfWeek(int hour, int minute) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//
//     // Adjust to the next week on the same day
//     return scheduleDate.isBefore(now)
//         ? scheduleDate.add(const Duration(days: 7))
//         : scheduleDate;
//   }
//
//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     final String timeZone = tz.local.name;
//     tz.setLocalLocation(tz.getLocation(timeZone));
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_task_planner_app/model/task_model.dart';

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotifyHelper() {
    initializeNotification();
  }

  Future<void> initializeNotification() async {
    try {
      await _configureLocalTimeZone();

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );

      await _requestNotificationPermissions();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _requestNotificationPermissions() async {
    if (GetPlatform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (GetPlatform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _handleNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      selectNotification(notificationResponse.payload);
    }
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    try {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );

      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: title,
      );
    } catch (e) {
      debugPrint('Error displaying notification: $e');
    }
  }

  Future<void> scheduledNotification(int hour, int minute, Task task) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.description,
        _convertTime(hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel_id',
            'Task Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        // androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "Task: ${task.title}\nNote: ${task.description}",
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> createDailyReminder(int hour, int minute, Task task) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.description,
        _getNextInstanceOfTime(hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        // androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "Daily Reminder: ${task.title}\nNote: ${task.description}",
      );
    } catch (e) {
      debugPrint('Error creating daily reminder: $e');
    }
  }

  Future<void> scheduledWeeklyNotification(
      int hour, int minute, Task task) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.description,
        _getNextInstanceOfWeek(hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'weekly_reminder_channel',
            'Weekly Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        // androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: "Weekly Reminder: ${task.title}\nNote: ${task.description}",
      );
    } catch (e) {
      debugPrint('Error scheduling weekly notification: $e');
    }
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
      // Navigate to the desired page based on the payload
      // Example: Get.to(() => TaskDetailPage(payload: payload));
    }
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  tz.TZDateTime _getNextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;
  }

  tz.TZDateTime _getNextInstanceOfWeek(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 7))
        : scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = tz.local.name;
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
