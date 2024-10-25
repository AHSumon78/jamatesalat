import 'package:flutter/material.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';

import 'Details.dart';
import 'alarm.dart';

bool location = false;

bool isInitialized = false;
Color iconColor = Colors.blue;
Color bgColor = Colors.black;
Color textColor = Colors.white;
Color alarmColor = const Color.fromARGB(255, 221, 3, 17);

List<Alarm> alarms = [];
List<String> mosque = [];
List<Details> details = [
  Details(
      title: "Fajr",
      body: "Go for salah or you will miss jamat",
      time: const TimeOfDay(hour: 4, minute: 30)),
  Details(
      title: "Dhurh",
      body: "Go for salah or you will miss jamat",
      time: const TimeOfDay(hour: 13, minute: 30)),
  Details(
      title: "Ashr",
      body: "Go for salah or you will miss jamat",
      time: const TimeOfDay(hour: 16, minute: 00)),
  Details(
      title: "Maghrib",
      body: "Go for salah or you will miss jamat",
      time: const TimeOfDay(hour: 18, minute: 00)),
  Details(
      title: "Isha",
      body: "Go for salah or you will miss jamat",
      time: const TimeOfDay(hour: 20, minute: 00))
];
void toggle() async {
  if (location) {
    for (int i = 0; i < 5; i++) {
      if (await NotificationController().isNotificationScheduled(i)) {
        NotificationController().cancelNotification(i);
      }
      if (alarms[i + 5].status) {
        print(i + 5);
        print(alarms[i + 5].title);
        print(alarms[i + 5].time);
        NotificationController().scheduleAlarm(alarms[i + 5]);
      }
    }
  } else {
    for (int i = 5; i < 10; i++) {
      if (await NotificationController().isNotificationScheduled(i)) {
        NotificationController().cancelNotification(i);
      }
      if (alarms[i - 5].status) {
        print(i - 5);
        print(alarms[i - 5].title);
        print(alarms[i - 5].time);
        NotificationController().scheduleAlarm(alarms[i - 5]);
      }
    }
  }
}

void enableNotification(int index) {
  //  bool screenOn = _screenStateEvent == ScreenStateEvent.SCREEN_ON;
  NotificationController().scheduleAlarm(Alarm(
          id: index,
          title: alarms[index].title,
          body: alarms[index].body,
          time: alarms[index].time,
          status: alarms[index].status,
          init: true,
          sound: true,
          defaultSound: false)
      // screenOn,
      );
}
