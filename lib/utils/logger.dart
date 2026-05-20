import 'package:flutter/foundation.dart';

/// A simple logging utility that respects debug/release modes
class AppLogger {
  static const String _tag = 'TaskMate';

  /// Log debug information (only in debug mode)
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] DEBUG: $message');
    }
  }

  /// Log information (only in debug mode)
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] INFO: $message');
    }
  }

  /// Log warnings (only in debug mode)
  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] WARNING: $message');
    }
  }

  /// Log errors (always logged)
  static void e(String message, {String? tag}) {
    debugPrint('[${tag ?? _tag}] ERROR: $message');
  }

  /// Log database operations
  static void db(String message) {
    if (kDebugMode) {
      debugPrint('[$_tag] DB: $message');
    }
  }

  /// Log network operations
  static void network(String message) {
    if (kDebugMode) {
      debugPrint('[$_tag] NETWORK: $message');
    }
  }

  /// Log authentication operations
  static void auth(String message) {
    if (kDebugMode) {
      debugPrint('[$_tag] AUTH: $message');
    }
  }
}
