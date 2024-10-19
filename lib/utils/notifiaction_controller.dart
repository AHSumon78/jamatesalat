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
            channelKey: 'alarm_channel',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for alarms',
            defaultColor: const Color.fromARGB(255, 157, 80, 221),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            soundSource: 'resource://raw/fazar',
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            enableVibration: true,
            onlyAlertOnce: false,
          ),
          NotificationChannel(
            channelKey: 'alarm_channel2',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for alarms',
            defaultColor: const Color.fromARGB(255, 157, 80, 221),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            soundSource: 'resource://raw/azan',
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            enableVibration: true,
            onlyAlertOnce: false,
          ),
        ]);
    bool isPermit = await AwesomeNotifications().isNotificationAllowed();
    if (!isPermit) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void scheduleAlarm(Alarm alarm) async {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
        now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
    String? soundSource =
        (alarm.id == 0) ? 'resource://raw/azan' : 'resource://raw/fazar';

    String channel1 = "alarm_channel";
    String channel2 = "alarm_channel2";

    // If the alarm time has already passed today, set it for tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    print('Scheduling alarm for: $alarmTime');
    print(soundSource);
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: alarm.id,
          channelKey: (alarm.id == 0 || alarm.id == 5) ? channel1 : channel2,
          title: alarm.title,
          body: alarm.body,
          notificationLayout: NotificationLayout.BigText,
          wakeUpScreen: true,
          customSound: soundSource,
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