import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';

class AppPreferences {
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyDefaultCategoriesAdded = 'default_categories_added';

  // Check if this is the first time the app is launched
  static Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyFirstLaunch) ??
          true; // true if key doesn't exist
    } catch (e) {
      AppLogger.e('Error checking first launch: $e');
      return true; // Assume first launch on error
    }
  }

  // Mark that the app has been launched before
  static Future<void> setFirstLaunchCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstLaunch, false);
      AppLogger.d('First launch marked as completed');
    } catch (e) {
      AppLogger.e('Error setting first launch completed: $e');
    }
  }

  // Check if default categories have been added
  static Future<bool> areDefaultCategoriesAdded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyDefaultCategoriesAdded) ?? false;
    } catch (e) {
      AppLogger.e('Error checking default categories: $e');
      return false;
    }
  }

  // Mark that default categories have been added
  static Future<void> setDefaultCategoriesAdded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyDefaultCategoriesAdded, true);
      AppLogger.d('Default categories marked as added');
    } catch (e) {
      AppLogger.e('Error setting default categories added: $e');
    }
  }

  // Reset all preferences (for testing purposes)
  static Future<void> resetPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      AppLogger.d('All preferences cleared');
    } catch (e) {
      AppLogger.e('Error clearing preferences: $e');
    }
  }

  // Reset only category preferences (for testing purposes)
  static Future<void> resetCategoryPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyDefaultCategoriesAdded);
      AppLogger.d('Category preferences cleared');
    } catch (e) {
      AppLogger.e('Error clearing category preferences: $e');
    }
  }
}
