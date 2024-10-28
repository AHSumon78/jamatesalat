import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm {
  int id;
  String title;
  String body;
  TimeOfDay time;
  bool status;
  bool init;
  bool sound;
  bool defaultSound;

  get getId => id;
  get getTitle => title;
  get getBody => body;
  get getTime => time;

  // int _priority;
  Alarm({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.status,
    required this.init,
    required this.sound,
    required this.defaultSound,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'hour': time.hour,
        'minute': time.minute,
        'status': status,
        'init': init,
        'sound': sound,
        'defaultSound': defaultSound
      };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      status: json['status'],
      init: json['init'],
      sound: json['sound'],
      defaultSound: json['defaultSound']);
  @override
  String toString() {
    // ignore: prefer_interpolation_to_compose_strings
    return 'id: $id title: $title description: $body time: $time status: $status init: $init';
  }
}

class AlarmStorage {
  static const String _key = 'alarms';

  static Future<void> saveAlarms(List<Alarm> alarms) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<List<Alarm>> loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Alarm.fromJson(json)).toList();
    }
    return [];
  }
}

class LocationStorage {
  static Future<void> saveLocation(
      String first,
      String second,
      int firstTime,
      int secondTime,
      double flat,
      double flong,
      double slat,
      double slong) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location_first', first);
    await prefs.setString('location_second', second);
    await prefs.setInt('timeA', firstTime);
    await prefs.setInt('timeB', secondTime);
    await prefs.setDouble('flat', flat);
    await prefs.setDouble('flong', flong);
    await prefs.setDouble('slat', slat);
    await prefs.setDouble('slong', slong);
  }

  static Future<Map<String, dynamic>> loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? first = prefs.getString('location_first');
    String? second = prefs.getString('location_second');
    int? timeA = prefs.getInt('timeA');
    int? timeB = prefs.getInt('timeB');
    double? flat = prefs.getDouble('flat');
    double? flong = prefs.getDouble('flong');
    double? slat = prefs.getDouble('slat');
    double? slong = prefs.getDouble('slong');
    return {
      'first': first ?? '',
      'second': second ?? '',
      'timeA': timeA ?? 0,
      'timeB': timeB ?? 0,
      'flat': flat ?? 23,
      'flong': flong ?? 90,
      'slat': slat ?? 22,
      'slong': slong ?? 88,
    };
  }
}
