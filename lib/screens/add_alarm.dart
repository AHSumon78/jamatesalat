import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Details.dart';
import 'package:jamatesalat/models/alarm.dart';
import '../models/global_function.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  AddAlarmState createState() => AddAlarmState();
}

class AddAlarmState extends State<AddAlarm> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  Details detailx = Details(
      title: "Alarm",
      body: "massage",
      time: const TimeOfDay(hour: 7, minute: 0));
  bool daily = false;

  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(alarms);
  }

  void _addAlarm(Alarm alarm) {
    setState(() {
      alarms.add(alarm);
      _saveAlarms();
    });
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: detailx.time,
    );
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        detailx.time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Alarm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: bgColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        onPressed: () {
          _addAlarm(Alarm(
              id: alarms.length,
              title: detailx.title,
              body: detailx.body,
              time: detailx.time,
              status: false,
              init: daily,
              sound: true,
              defaultSound: true));
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.save,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 172, 173, 171),
              Color.fromARGB(255, 179, 183, 184)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    "Title",
                    style: TextStyle(color: textColor, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    maxLength: 10,
                    controller: title,
                    onChanged: (value) {
                      setState(() {
                        detailx.title = title.text;
                      });
                      debugPrint('second: $value');
                    },
                    decoration: const InputDecoration(
                      hintText: 'title',
                    ),
                    style: TextStyle(
                      color: textColor, // Set your desired text color here
                      fontSize: 18.0, // Optionally, set the font size
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    "Message",
                    style: TextStyle(color: textColor, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    maxLength: 30,
                    controller: body,
                    onChanged: (value) {
                      setState(() {
                        detailx.body = body.text;
                      });
                      debugPrint('second: $value');
                    },
                    decoration: const InputDecoration(
                      hintText: 'message',
                    ),
                    style: TextStyle(
                      color: textColor, // Set your desired text color here
                      fontSize: 18.0, // Optionally, set the font size
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 50,
                  child: Text(
                    "Time",
                    style: TextStyle(color: textColor, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      pickTime(context);
                    },
                    child: Text(
                      detailx.time.format(context),
                      style: TextStyle(color: textColor, fontSize: 35),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    "Daily",
                    style: TextStyle(color: textColor, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
                Checkbox(
                  value: daily,
                  onChanged: (value) {
                    setState(() {
                      daily = !daily;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
