import 'package:flutter/material.dart';
import 'package:jamatesalat/models/alarm.dart';
import 'package:jamatesalat/screens/add_alarm.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';
import '../models/global_function.dart';

class OthersAlarm extends StatefulWidget {
  const OthersAlarm({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<OthersAlarm> {
  bool delete = false;
  int id = -1;
  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(alarms);
  }

  void alarmRemove(int index) {
    alarms.removeAt(index);
    print(index);
    setState(() {
      alarms;
      _saveAlarms();
    });
  }

  Future<void> pickTime(BuildContext context, id) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: alarms[id].time,
    );
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        alarms[id].time = picked;
        _saveAlarms();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alarm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: bgColor),
        ),
        actions: [
          if (delete)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      delete = false;
                      id = -1;
                    });
                  },
                  child: const Icon(Icons.cancel),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      id = id + 10;
                      if (alarms[id].status) {
                        cancelAlarm(id);
                      }
                      if (id > 9) {
                        alarmRemove(id);
                      }
                      print(id);
                      id = -1;
                      delete = false;
                    });
                  },
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        onPressed: () async {
          if (alarms.length < 16) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAlarm(),
                ));
            setState(() {
              alarms;
            });
          }
        },
        child: alarms.length < 16
            ? const Icon(Icons.add_alarm)
            : const Text("Stop"),
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
          children: [
            Expanded(
              child: alarms.length < 11
                  ? const Center(
                      child: Text(
                      "Add your Alarms",
                      style: TextStyle(fontSize: 30),
                    ))
                  : _location(10),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  ListView _location(int start) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: alarms.length - 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            setState(() {
              delete = !delete;
              if (delete) {
                id = index;
              } else {
                id = -1;
              }
            });
            print(delete);
          },
          child: Card(
            color: (delete && id == index)
                ? Colors.grey
                : bgColor, // Transparent background// No shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: textColor),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 85,
                      child: Text(
                        alarms[index + start].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: textColor),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!alarms[index + start].status) {
                          pickTime(context, index + start);
                        }
                      },
                      child: Text(
                        alarms[index + start].time.format(context),
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(alarms[index + start].body),
                trailing: Transform.scale(
                    scaleX: 0.7,
                    scaleY: 0.6,
                    child: Switch(
                      value: alarms[index + start].status,
                      onChanged: (value) {
                        setState(() {
                          alarms[index + start].status =
                              !alarms[index + start].status;
                        });
                        if (alarms[index + start].status) {
                          enableAlarm(index + start);
                        } else {
                          cancelAlarm(index + start);
                        }
                      },
                      activeColor: const Color.fromARGB(
                          255, 226, 227, 231), // Thumb color when active
                      activeTrackColor: const Color.fromARGB(
                          255, 109, 125, 247), // Track color when active
                      inactiveThumbColor: const Color.fromARGB(
                          255, 211, 217, 213), // Thumb color when inactive
                      inactiveTrackColor:
                          const Color.fromARGB(255, 168, 171, 167),
                    ))),
          ),
        );
      },
    );
  }

  void enableAlarm(int id) {
    NotificationController().scheduleAlarmOthers(alarms[id]);
  }

  void cancelAlarm(int id) {
    NotificationController().cancelNotification(id);
  }
}
/*            NumberPicker(
              value: _currentValue,
              minValue: 1,
              maxValue: 29,
              onChanged: (value) => setState(() => _currentValue = value),
            ),*/