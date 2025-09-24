import 'package:flutter/material.dart';

import '../../theme/colors/light_colors.dart';

void showAppInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: LightColors.kDarkYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.task_alt,
              color: LightColors.kDarkYellow,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'TaskMate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: LightColors.kDarkBlue,
            ),
          ),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version: 1.0.0',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'A powerful task management app built with Flutter.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            'Features:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            '• Create and organize tasks\n• Set reminders and notifications\n• Track progress with categories\n• Voice input support\n• Beautiful UI design',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: LightColors.kDarkYellow,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}