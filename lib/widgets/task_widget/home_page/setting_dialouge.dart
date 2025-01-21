import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/service/notification_services.dart';

void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingsDialog();
    },
  );
}

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _isDarkTheme = false;
  bool _isBackupEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('Switch Theme'),
            value: _isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                NotifyHelper()
                    .displayNotification(title: "Theme", body: 'Theme Changed');
                _isDarkTheme = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Firebase Backup'),
            value: _isBackupEnabled,
            onChanged: (bool value) {
              setState(() {
                value
                    ? NotifyHelper().displayNotification(
                        title: "Firebase Backup", body: 'Backup is  Enable')
                    : NotifyHelper().displayNotification(
                        title: "Firebase Backup", body: 'Backup is disable');
                _isBackupEnabled = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
