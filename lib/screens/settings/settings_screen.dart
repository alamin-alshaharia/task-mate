import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/controller/data_sync_manager.dart';
import 'package:flutter_task_planner_app/controller/profile_controller.dart';
import 'package:flutter_task_planner_app/screens/settings/notification_settings_page.dart';
import 'package:flutter_task_planner_app/screens/settings/profile_edit_screen.dart';
import 'package:flutter_task_planner_app/screens/test/notification_test_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/show_appinfo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: LightColors.kDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: LightColors.kDarkBlue),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [LightColors.kDarkYellow, Color(0xFFFFD54F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: LightColors.kDarkYellow.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Settings',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Manage your app preferences',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'General',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LightColors.kDarkBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Profile Section
              Obx(() => _buildSettingsTile(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle:
                        (profileController.profile.value.name?.isNotEmpty ??
                                false)
                            ? profileController.profile.value.name!
                            : 'Set up your profile',
                    onTap: () {
                      // Navigate to profile edit screen
                      Get.to(() => const ProfileEditScreen());
                    },
                  )),

              const SizedBox(height: 8),

              // Notifications
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => _showNotificationSettings(context),
              ),

              const SizedBox(height: 8),

              // Notification Test (Debug)
              _buildSettingsTile(
                icon: Icons.bug_report,
                title: 'Test Notifications',
                subtitle: 'Debug notification functionality',
                onTap: () => Get.to(() => const NotificationTestPage()),
              ),

              const SizedBox(height: 8),

              // Clear Tasks Only
              _buildSettingsTile(
                icon: Icons.delete_outline,
                title: 'Clear All Tasks',
                subtitle: 'Delete all tasks but keep profile',
                onTap: () => _showClearTasksDialog(context),
                isDestructive: true,
              ),

              const SizedBox(height: 8),

              // Reset Onboarding
              _buildSettingsTile(
                icon: Icons.refresh,
                title: 'Reset Onboarding',
                subtitle: 'Show welcome screens again',
                onTap: () => _showResetOnboardingDialog(context),
              ),

              const SizedBox(height: 8),

              // Clear Data
              _buildSettingsTile(
                icon: Icons.delete_sweep,
                title: 'Clear App Data',
                subtitle: 'Reset all app data and settings',
                onTap: () => _showClearDataDialog(context),
                isDestructive: true,
              ),

              const SizedBox(height: 32),

              const Text(
                'Data Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LightColors.kDarkBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Export Data
              _buildSettingsTile(
                icon: Icons.file_download,
                title: 'Export Data',
                subtitle: 'Backup your tasks and profile',
                onTap: () => _showExportDialog(context),
              ),

              const SizedBox(height: 8),

              // Import Data
              _buildSettingsTile(
                icon: Icons.file_upload,
                title: 'Import Data',
                subtitle: 'Restore from backup file',
                onTap: () => _showImportDialog(context),
              ),

              const SizedBox(height: 32),

              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LightColors.kDarkBlue,
                ),
              ),
              const SizedBox(height: 16),

              // App Version
              _buildSettingsTile(
                icon: Icons.info,
                title: 'App Version',
                subtitle: 'TaskMate v1.0.0',
                onTap: () => showAppInfoDialog(context),
              ),

              const SizedBox(height: 8),

              // Developer Info
              _buildSettingsTile(
                icon: Icons.code,
                title: 'Developer',
                subtitle: 'Built with Flutter',
                onTap: () => _showDeveloperInfo(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDestructive ? Colors.red : LightColors.kDarkYellow)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : LightColors.kDarkYellow,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : LightColors.kDarkBlue,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: onTap != null
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showResetOnboardingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Reset Onboarding',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: LightColors.kDarkBlue,
          ),
        ),
        content: const Text(
          'This will show the welcome screens again when you restart the app. Your profile and data will remain intact.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _resetOnboarding();
              Navigator.pop(context);
              Get.snackbar(
                'Success',
                'Onboarding has been reset. Restart the app to see welcome screens.',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColors.kDarkYellow,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear App Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'This will permanently delete all your tasks, categories, and profile data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _clearAppData();
              Navigator.pop(context);
              Get.snackbar(
                'Data Cleared',
                'All app data has been cleared. Onboarding will show on next restart.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
  }

  Future<void> _clearAppData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear all data using DataSyncManager for proper UI sync
      final DataSyncManager dataSyncManager = Get.find<DataSyncManager>();
      await dataSyncManager.clearAllData();
    } catch (e) {
      AppLogger.e('Error clearing app data: $e');
      rethrow;
    }
  }

  void _showNotificationSettings(BuildContext context) {
    // Navigate to the comprehensive notification settings page
    Get.to(() => const NotificationSettingsPage());
  }

  void _showClearTasksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'This will permanently delete all your tasks and categories. Your profile data will remain intact. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _clearAllTasks();
              Navigator.pop(context);
              Get.snackbar(
                'Tasks Cleared',
                'All tasks have been deleted successfully',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear Tasks'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllTasks() async {
    try {
      final DataSyncManager dataSyncManager = Get.find<DataSyncManager>();
      await dataSyncManager.deleteAllTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear tasks: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Export Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: LightColors.kDarkBlue,
          ),
        ),
        content: const Text(
          'Export your tasks and profile data to a backup file. This will help you restore your data later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Coming Soon',
                'Export functionality will be available soon',
                backgroundColor: LightColors.kDarkYellow,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColors.kDarkYellow,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Import Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: LightColors.kDarkBlue,
          ),
        ),
        content: const Text(
          'Restore your tasks and profile data from a backup file. This will replace your current data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Coming Soon',
                'Import functionality will be available soon',
                backgroundColor: LightColors.kDarkYellow,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColors.kDarkYellow,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Developer Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: LightColors.kDarkBlue,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Built with Flutter 💙',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Text(
              'Technologies Used:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '• Flutter Framework\n• GetX State Management\n• SQLite Database\n• Material Design\n• Local Storage',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Text(
              'Made with ❤️ for productivity enthusiasts',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Contact:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              'alaminalshaharia@gmail.com',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
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
}
