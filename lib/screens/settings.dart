import 'package:flutter/material.dart';
import 'package:jamatesalat/models/global_function.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';

import '../models/alarm.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return settingsState();
  }
}

class settingsState extends State<Settings> {
  double cardHieght = 50;
  double cardWidth = 350;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NMJammat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 16, 241, 38),
                Color.fromARGB(255, 20, 31, 24)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              shape: Border(bottom: BorderSide(color: textColor)),
              color: bgColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 54,
                    child: Text(
                      "Alarm",
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Sound",
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Default",
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: Border(bottom: BorderSide(color: textColor)),
                  color: bgColor,
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHieght,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 55,
                          child: Text(
                            details[index].title,
                            style: TextStyle(
                                color: textColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Checkbox(
                          value: alarms[index].sound,
                          onChanged: (value) {
                            setState(() {
                              alarms[index].sound = !alarms[index].sound;
                              alarms[index + 5].sound = !alarms[index].sound;
                              if (!alarms[index].sound) {
                                alarms[index].defaultSound = false;
                              }
                              _saveAlarms();
                            });
                            reschedule(index);
                          },
                        ),
                        Checkbox(
                          value: alarms[index].defaultSound,
                          onChanged: (value) {
                            if (alarms[index].sound) {
                              setState(() {
                                alarms[index].defaultSound =
                                    !alarms[index].defaultSound;
                                alarms[index + 5].defaultSound =
                                    !alarms[index].defaultSound;
                                _saveAlarms();
                              });

                              reschedule(index);
                            }
                          },
                        )
                      ],
                    )),
                  ),
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the popup
        },
        child: const Text('Close'),
      ),
    );
  }

  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(alarms);
  }

  void reschedule(int index) {
    if (alarms[index].status) {
      NotificationController().cancelNotification(index);
      NotificationController().scheduleAlarm(alarms[index]);
    }
    if (alarms[index + 5].status) {
      NotificationController().cancelNotification(index + 5);
      NotificationController().scheduleAlarm(alarms[index + 5]);
    }
  }
}
