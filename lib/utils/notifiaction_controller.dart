import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:jamatesalat/models/alarm.dart';

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  void initializeNotifications() async {
    AwesomeNotifications().initialize(
        null, // default icon
        [
          NotificationChannel(
            channelKey: 'fajr',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for alarms',
            defaultColor: const Color.fromARGB(255, 157, 80, 221),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            playSound: true,
            soundSource: 'resource://raw/fazar',
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            onlyAlertOnce: false,
          ),
          NotificationChannel(
            channelKey: 'azan',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for alarms',
            defaultColor: const Color.fromARGB(255, 157, 80, 221),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            soundSource: 'resource://raw/azan',
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            onlyAlertOnce: false,
          ),
          NotificationChannel(
            channelKey: 'no_sound',
            channelName: 'Vibrate notifications',
            channelDescription: 'Notification channel with vibration',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: false,
            enableVibration: true,
          ),
          NotificationChannel(
            channelKey: 'default',
            channelName: 'Vibrate notifications',
            channelDescription: 'Notification channel with vibration',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            enableVibration: true,
          ),
        ]);
    bool isPermit = await AwesomeNotifications().isNotificationAllowed();
    if (!isPermit) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void cancelChannel(String channel) {
    AwesomeNotifications().removeChannel(channel);
  }

  void setChannel(String file) {
    cancelChannel("default");
    AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: 'default',
        channelName: 'Vibrate notifications',
        channelDescription: 'Notification channel with vibration',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        soundSource: 'file://$file',
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        enableVibration: true,
      ),
    );
  }

  void scheduleAlarm(Alarm alarm) async {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
        now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);

    String channel1 = "fajr";
    String channel2 = "azan";
    String channel3 = "no_sound";
    String channel4 = "default";

    // If the alarm time has already passed today, set it for tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    print('Scheduling alarm for: $alarmTime');

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: alarm.id,
          channelKey: alarm.sound
              ? (alarm.defaultSound
                  ? channel4
                  : (alarm.id == 0 || alarm.id == 5)
                      ? channel1
                      : channel2)
              : channel3,
          title: alarm.title,
          body: alarm.body,
          notificationLayout: NotificationLayout.BigText,
          wakeUpScreen: true,
          category: NotificationCategory.Alarm,
          duration: Duration(minutes: (alarm.id == 0 || alarm.id == 5) ? 2 : 1),
          timeoutAfter:
              Duration(minutes: (alarm.id == 0 || alarm.id == 5) ? 2 : 1),

          //    alarm.id == 0 ? 'resource://raw/assalatu_khairum_minan' : null
        ),
        schedule: NotificationCalendar(
          hour: alarm.time.hour,
          minute: alarm.time.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
          preciseAlarm: true,
        ));
  }

  void scheduleAlarmOthers(Alarm alarm) async {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
        now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
    String channel4 = "default";

    // If the alarm time has already passed today, set it for tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    print('Scheduling alarm for: $alarmTime');

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: alarm.id,
          channelKey: channel4,
          title: alarm.title,
          body: alarm.body,
          notificationLayout: NotificationLayout.BigText,
          wakeUpScreen: true,
          category: NotificationCategory.Alarm,
          duration: const Duration(minutes: 1),
          timeoutAfter: const Duration(minutes: 1),

          //    alarm.id == 0 ? 'resource://raw/assalatu_khairum_minan' : null
        ),
        schedule: NotificationCalendar(
          hour: alarm.time.hour,
          minute: alarm.time.minute,
          second: 0,
          millisecond: 0,
          repeats: alarm.init,
          allowWhileIdle: true,
          preciseAlarm: true,
        ));
  }
  //alarm

  void cancelNotification(int id) {
    AwesomeNotifications().cancel(id);
  }

  Future<bool> isNotificationScheduled(int id) async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    for (var notification in scheduledNotifications) {
      if (notification.content?.id == id) {
        return true;
      }
    }
    return false;
  }
}
//assets\images\Blue White Illustration Mosque Paper Border.png