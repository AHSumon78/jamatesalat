import 'package:flutter/material.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';

import 'Details.dart';
import 'alarm.dart';

bool location = false;
bool hasPermission = false;

bool isInitialized = false;
Color iconColor = const Color.fromARGB(255, 15, 16, 10);
Color bgColor = const Color.fromARGB(255, 174, 178, 150); // Fully opaque
Color textColor = const Color.fromARGB(255, 4, 0, 0);
Color alarmColor = const Color.fromARGB(255, 221, 3, 17);
Color greenColor = const Color.fromARGB(255, 5, 229, 13);
Color skyColor = const Color.fromARGB(255, 107, 203, 227);
List<Alarm> alarms = [];
List<String> mosque = ["", ""];
int timeA = 0;
int timeB = 0;
double flat = 23;
double flong = 90;
double slat = 22;
double slong = 98;
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
/*void toggle() async {
  if (location) {
    for (int i = 0; i < 5; i++) {
      if (alarms[i].status) {
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
      if (alarms[i].status) {
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
*/
void enableNotification(int index) {
  //  bool screenOn = _screenStateEvent == ScreenStateEvent.SCREEN_ON;
  NotificationController().scheduleAlarm(Alarm(
      id: index,
      title: alarms[index].title,
      body: alarms[index].body,
      time: subtractMinutesFromTimeOfDay(
          alarms[index].time, index < 5 ? timeA : timeB),
      status: true,
      init: alarms[index].init,
      sound: alarms[index].sound,
      defaultSound: alarms[index].defaultSound));
}

void enableWhichEanabled() async {
  if (location) {
    for (int i = 5; i < 10; i++) {
      if (alarms[i].status) {
        NotificationController().cancelNotification(i);
        enableNotification(i);
      }
    }
  } else {
    for (int i = 0; i < 5; i++) {
      if (alarms[i].status) {
        NotificationController().cancelNotification(i);
        enableNotification(i);
      }
    }
  }
}

TimeOfDay addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final newDt = dt.add(Duration(minutes: minutesToAdd));
  return TimeOfDay(hour: newDt.hour, minute: newDt.minute);
}

TimeOfDay subtractMinutesFromTimeOfDay(TimeOfDay time, int minutesToSubtract) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final newDt = dt.subtract(Duration(minutes: minutesToSubtract));
  return TimeOfDay(hour: newDt.hour, minute: newDt.minute);
}

void saveLoc() {
  alarms[0].init = location;
}
