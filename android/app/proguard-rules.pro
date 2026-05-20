# Flutter-specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep SQLite
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Keep local notifications
-keep class com.dexterous.** { *; }

# Prevent R8 from stripping interfaces
-dontwarn com.google.android.play.core.**

# Keep fluttertoast classes to fix R8 missing class errors
-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }
-dontwarn io.github.ponnamkarthik.toast.fluttertoast.**

# Keep AndroidX Startup classes to fix ANR/Crash (NoClassDefFoundError: androidx/startup/R$string)
-keep class androidx.startup.** { *; }
-keep class androidx.startup.R$** { *; }
