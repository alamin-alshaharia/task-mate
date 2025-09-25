import 'package:intl/intl.dart';

/// Utility class for consistent time parsing across the app
class TimeParser {
  /// Parse time string in 12-hour format (e.g., "09:30 AM") to DateTime
  static DateTime parseTimeString(String timeString, {bool from5am = false}) {
    try {
      final now = DateTime.now();

      // Use robust time parsing with regex
      final timeRegex = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
      final match = timeRegex.firstMatch(timeString.trim().toUpperCase());

      if (match == null) {
        throw FormatException(
            'Invalid time format: $timeString. Expected format: HH:MM AM/PM');
      }

      int hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3)!;

      // Convert to 24-hour format
      if (period == 'PM' && hours != 12) {
        hours += 12;
      } else if (period == 'AM' && hours == 12) {
        hours = 0;
      }

      // Validate parsed values
      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw FormatException('Invalid time values: $hours:$minutes');
      }

      var dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hours,
        minutes,
      );

      // If from5am is true and time is before 5 AM, add a day
      if (from5am && dateTime.hour < 5) {
        dateTime = dateTime.add(const Duration(days: 1));
      }

      return dateTime;
    } catch (e) {
      throw FormatException('Error parsing time string "$timeString": $e');
    }
  }

  /// Parse time string and return hours and minutes as integers
  static ({int hours, int minutes}) parseTimeToHoursMinutes(String timeString) {
    try {
      final timeRegex = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
      final match = timeRegex.firstMatch(timeString.trim().toUpperCase());

      if (match == null) {
        throw FormatException(
            'Invalid time format: $timeString. Expected format: HH:MM AM/PM');
      }

      int hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      final period = match.group(3)!;

      // Convert to 24-hour format
      if (period == 'PM' && hours != 12) {
        hours += 12;
      } else if (period == 'AM' && hours == 12) {
        hours = 0;
      }

      // Validate parsed values
      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw FormatException('Invalid time values: $hours:$minutes');
      }

      return (hours: hours, minutes: minutes);
    } catch (e) {
      throw FormatException('Error parsing time string "$timeString": $e');
    }
  }

  /// Validate if a time string is in correct format
  static bool isValidTimeFormat(String timeString) {
    try {
      parseTimeToHoursMinutes(timeString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Format DateTime to 12-hour format string
  static String formatTo12Hour(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format DateTime to 24-hour format string
  static String formatTo24Hour(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Convert 24-hour format string to 12-hour format string
  static String convert24To12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) {
        throw FormatException('Invalid 24-hour format: $time24');
      }

      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw FormatException('Invalid time values: $hours:$minutes');
      }

      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, hours, minutes);

      return formatTo12Hour(dateTime);
    } catch (e) {
      throw FormatException('Error converting 24-hour time "$time24": $e');
    }
  }

  /// Convert 12-hour format string to 24-hour format string
  static String convert12To24Hour(String time12) {
    try {
      final parsed = parseTimeToHoursMinutes(time12);
      return '${parsed.hours.toString().padLeft(2, '0')}:${parsed.minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      throw FormatException('Error converting 12-hour time "$time12": $e');
    }
  }
}
