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
  double cardHeight = 50;
  double cardWidth = 350;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NMJammat',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 132, 136, 124), Color(0xFFe0f7fa)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Alarm",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Sound",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Default",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    color: bgColor.withOpacity(0.9),
                    child: SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                details[index].title,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: alarms[index].sound,
                              onChanged: (value) {
                                setState(() {
                                  alarms[index].sound = !alarms[index].sound;
                                  alarms[index + 5].sound = alarms[index].sound;
                                  if (!alarms[index].sound) {
                                    alarms[index].defaultSound = false;
                                    alarms[index + 5].defaultSound = false;
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        onPressed: () {
          Navigator.of(context).pop(); // Close the popup
        },
        child: const Icon(Icons.close),
      ),
    );
  }

  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(alarms);
  }

  void reschedule(int index) {
    if (alarms[index].status && !location) {
      NotificationController().cancelNotification(index);
      enableNotification(index);
    }
    if (alarms[index + 5].status && location) {
      NotificationController().cancelNotification(index + 5);
      enableNotification(index + 5);
    }
  }
}
