import 'package:flutter/material.dart';

class Details {
  String title;
  String body;
  TimeOfDay time;
  get getTitle => title;
  get getBody => body;
  Details({
    required this.title,
    required this.body,
    required this.time,
  });
}
