# Preserve classes for awesome_notifications
-keep class me.carda.awesome_notifications.** { *; }

# Preserve permission_handler classes
-keep class com.baseflow.permissionhandler.** { *; }

# Preserve shared_preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.example.screenstate.** { *; }
-keepclassmembers class com.example.screenstate.** { *; }
-dontwarn com.example.screenstate.**

# NumberPicker
-keep class com.github.shawnlin.numberpicker.** { *; }

# OpenStreetMapSearchAndPick
-keep class com.yourpackage.openstreetmapsearchandpick.** { *; }

# Islamic Hijri Calendar
-keep class com.github.islamic_hijri_calendar.** { *; }

# UrlLauncher
-keep class io.flutter.plugins.urllauncher.** { *; }


# Preserve AndroidX lifecycle classes
-keep class androidx.lifecycle.** { *; }




