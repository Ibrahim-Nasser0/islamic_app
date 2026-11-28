# Flutter & Kotlin Native Alarm Engine Rules
-keep class com.example.islamic_app.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep flutter_local_notifications scheduled receivers & GSON types
-keep class com.dexterous.** { *; }

# Keep SQLite / Drift native bindings
-keep class org.sqlite.** { *; }
-keep class * extends java.lang.Throwable { *; }

# Suppress optional Play Core deferred component references in Flutter embedding
-dontwarn com.google.android.play.core.**

