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
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'hour': time.hour,
        'minute': time.minute,
        'status': status,
        'init': init
      };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        time: TimeOfDay(hour: json['hour'], minute: json['minute']),
        status: json['status'],
        init: json['init'],
      );
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
  static Future<void> saveLocation(String first, String second) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location_first', first);
    await prefs.setString('location_second', second);
  }

  static Future<Map<String, String>> loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? first = prefs.getString('location_first');
    String? second = prefs.getString('location_second');
    return {
      'first': first ?? '',
      'second': second ?? '',
    };
  }
}
