import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Location.dart';
import 'package:jamatesalat/models/alarm.dart';
import 'package:jamatesalat/screens/locations.dart';
import 'package:jamatesalat/screens/others_alarm.dart';
import 'package:jamatesalat/screens/settings.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/global_function.dart';

Future<void> requestPreciseAlarmPermission() async {
  var status = await Permission.scheduleExactAlarm.status;
  if (status.isGranted) {
    print("Precise alarm permission granted");
  } else {
    print("Requesting precise alarm permission...");
    var result = await Permission.scheduleExactAlarm.request();
    if (result.isGranted) {
      print("Precise alarm permission granted");
    } else {
      print("Precise alarm permission denied");
      // Optionally, show a dialog here to inform the user
    }
  }
}

void _checkPermission() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    if (await Permission.location.request().isGranted) {
      // Permission granted
    } else {
      // Permission denied
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Never Miss Jammat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AlarmPage(),
    );
  }
}

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  void initState() {
    super.initState();
    _loadAlarms();
    loadLocation();
    requestPreciseAlarmPermission();
    _checkPermission();
  }

  Future<void> _loadAlarms() async {
    List<Alarm> loadedAlarms = await AlarmStorage.loadAlarms();

    setState(() {
      alarms = loadedAlarms;
      if (loadedAlarms.isEmpty) {
        _initializeDefaultAlarms();
        location = alarms[0].init;
      } else {
        location = alarms[0].init;
      }
    });
  }

  //initalization of defult alarm if all is not stored
  void _initializeDefaultAlarms() {
    if (!isInitialized) {
      int start;
      for (int i = 0; i < 10; i++) {
        start = i;
        if (i > 4) {
          start -= 5;
        }
        alarms.add(Alarm(
            id: i,
            title: details[start].title,
            body: details[start].body,
            time: details[start].time,
            status: false,
            init: false,
            sound: true,
            defaultSound: false));
      }
      _saveAlarms();
      isInitialized = true;
    }
  }

  Future<void> _saveAlarms() async {
    await AlarmStorage.saveAlarms(alarms);
  }

  void saveLocation() async {
    await LocationStorage.saveLocation(
        mosque[0], mosque[1], timeA, timeB, flat, flong, slat, slong);
  }

  void loadLocation() async {
    Map<String, dynamic> location = await LocationStorage.loadLocation();
    if (mosque.isNotEmpty) {
      setState(() {
        mosque[0] = location['first']!;
        mosque[1] = location['second']!;
      });
    } else {
      setState(() {
        mosque.add(location['first']!);
        mosque.add(location['second']!);
      });
    }
    setState(() {
      timeA = location['timeA'];
      timeB = location['timeB'];
      flat = location['flat'];
      flong = location['flong'];
      slat = location['slat'];
      slong = location['slong'];
    });
    print('First: ${location['first']}, Second: ${location['second']}');
  }

  void _addAlarm(Alarm alarm) {
    setState(() {
      alarms.add(alarm);
      _saveAlarms();
    });
  }

  Future<void> pickTime(
    BuildContext context,
    int id,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: id < alarms.length ? alarms[id].time : TimeOfDay.now(),
    );
    if (picked != null && picked != TimeOfDay.now()) {
      if (alarms[id].status) {
        NotificationController().cancelNotification(id);
      }
      setState(() {
        alarms[id].time = picked;
        print(alarms[id].time);
        _saveAlarms();
      });
      if (alarms[id].status) {
        enableNotification(id);
      }
    }
  }

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
        actions: [
          Row(
            children: [
              GestureDetector(
                child: Icon(
                  Icons.pin_drop,
                  color: iconColor,
                ),
                onTap: () {
                  navLocation();
                },
              ),
              Text(
                mosque.isEmpty ? "Mosque" : mosque[location ? 1 : 0],
                style: TextStyle(color: textColor),
              ),
              const SizedBox(
                width: 10,
              ),
              Transform.scale(
                scale: .7,
                child: Switch(
                  value: location,
                  onChanged: (value) {
                    setState(() {
                      location = value;
                      alarms[0].init = location;
                      toggle();
                      _saveAlarms();
                    });
                  },
                  activeColor: const Color.fromARGB(255, 227, 227, 231),
                  activeTrackColor: const Color.fromARGB(255, 109, 125, 247),
                  inactiveThumbColor: const Color.fromARGB(255, 168, 172, 166),
                  inactiveTrackColor: const Color.fromARGB(255, 216, 211, 211),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: SizedBox(
        height: 400,
        child: Drawer(
          backgroundColor: bgColor,
          width: 240,
          // Adjust the width of the drawer
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            side: BorderSide(color: textColor),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home, color: iconColor),
                title: Text('Home',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: iconColor),
                title: Text('Settings',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.pin_drop, color: iconColor),
                title: Text('Set Locations',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  navLocation();
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: iconColor),
                title: Text('About',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(), // Adding a divider for better separation
              ListTile(
                leading: Icon(Icons.contact_mail, color: iconColor),
                title: Text('Contact Us',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  // Define your navigation logic here
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.help, color: iconColor),
                title: Text('Help',
                    style: TextStyle(fontSize: 18, color: textColor)),
                onTap: () {
                  // Define your navigation logic here
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          // Adjust the width of the drawer
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: Text(
                    'Remainder\n Before Jammat',
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(),
                Tooltip(
                  message: "Offset time for\n walking to mosque",
                  enableTapToDismiss: true,
                  preferBelow: false,
                  child: Text(location ? "$timeB m" : "$timeA m",
                      style: TextStyle(color: iconColor, fontSize: 28)),
                ),
              ],
            ),
            Expanded(
              child: locationOptions(),
            ),
            SizedBox(
              height: 125,
              child: Text(
                "Reminder for Jammat\nThat you shall not miss the jammat accidentaly",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 174, 178, 150)),
                elevation: WidgetStatePropertyAll(20),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OthersAlarm(),
                    ));
              },
              child: Text(
                "Others alarm",
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  ListView locationOptions() {
    if (!location) {
      return _location(0);
    } else {
      return _location(5);
    }
  }

  ListView _location(int start) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: (alarms.length - 5) < 0 ? 0 : 5,
      itemBuilder: (context, index) {
        return Card(
          color: bgColor,
          // Transparent background// No shadow
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
                  onTap: () => pickTime(context, index + start),
                  child: Text(
                    alarms[index + start].time.format(context),
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                    scaleX: 0.7,
                    scaleY: 0.6,
                    child: Switch(
                      value: alarms[index + start].status,
                      onChanged: (value) {
                        setState(() {
                          alarms[index + start].status = value;
                          _saveAlarms();
                          if (!alarms[index + start].status) {
                            NotificationController()
                                .cancelNotification(index + start);
                          } else {
                            enableNotification(index + start);
                          }
                        });
                      },
                      activeColor: const Color.fromARGB(
                          255, 226, 227, 231), // Thumb color when active
                      activeTrackColor: const Color.fromARGB(
                          255, 109, 125, 247), // Track color when active
                      inactiveThumbColor: const Color.fromARGB(
                          255, 211, 217, 213), // Thumb color when inactive
                      inactiveTrackColor:
                          const Color.fromARGB(255, 168, 171, 167),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  void navLocation() async {
    Location location = Location(
        first: mosque.isEmpty ? "" : mosque[0],
        second: mosque.isEmpty ? "" : mosque[1],
        timeA: timeA,
        timeB: timeB,
        flat: flat,
        flong: flong,
        slat: slat,
        slong: slong);
    final updateLocations = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Locations(location),
      ),
    );
    if (updateLocations != null) {
      setState(() {
        if (mosque.isEmpty) {
          mosque.add(updateLocations.first);
          mosque.add(updateLocations.second);
        } else {
          mosque[0] = updateLocations.first;
          mosque[1] = updateLocations.second;
        }
        timeA = updateLocations.timeA;
        timeB = updateLocations.timeB;
        flat = updateLocations.flat;
        flong = updateLocations.flong;
        slat = updateLocations.slat;
        slong = updateLocations.slong;
        print(",,,,,,");
        print(updateLocations.timeA);
        saveLocation();
        enableWhichEanabled();
      });
    }
  }
}
/*            NumberPicker(
              value: _currentValue,
              minValue: 1,
              maxValue: 29,
              onChanged: (value) => setState(() => _currentValue = value),
            ),*/