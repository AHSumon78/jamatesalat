import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Location.dart';
import 'package:jamatesalat/models/alarm.dart';
import 'package:jamatesalat/screens/locations.dart';
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
    await LocationStorage.saveLocation(mosque[0], mosque[1]);
  }

  void loadLocation() async {
    Map<String, String> location = await LocationStorage.loadLocation();
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
        actions: [
          Row(
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.pin_drop,
                  color: Color.fromARGB(255, 56, 4, 243),
                ),
                onTap: () {
                  navLocation();
                },
              ),
              Text(
                mosque.isEmpty ? "Mosque" : mosque[location ? 1 : 0],
                style: const TextStyle(
                    color: const Color.fromARGB(255, 254, 255, 255)),
              ),
              const SizedBox(
                width: 10,
              ),
              Transform.scale(
                scale: .9,
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
                  activeColor: const Color.fromARGB(255, 16, 4, 180),
                  activeTrackColor: const Color.fromARGB(255, 221, 209, 224),
                  inactiveThumbColor: const Color.fromARGB(255, 72, 239, 7),
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
          width: 200,
          // Adjust the width of the drawer
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            side: BorderSide(color: Colors.green),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Card(
                color: Colors.white
                    .withOpacity(0.0), // Transparent background// No shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 30,
                      child: Text(
                        'Never Miss Jammat',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 4, 237, 12)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Other alarm",
                        style: TextStyle(color: bgColor),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 225,
                child: Card(
                  color: Colors.white
                      .withOpacity(0.0), // Transparent background// No shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: locationOptions(),
              ),
            ],
          ),
        ],
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
      itemCount: (alarms.length - 5) < 0 ? 0 : (alarms.length - 5),
      itemBuilder: (context, index) {
        return Card(
          color: const Color.fromARGB(255, 179, 149, 244)
              .withOpacity(0.2), // Transparent background// No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color.fromARGB(255, 14, 245, 21)),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 65,
                  child: Text(
                    alarms[index + start].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: alarmColor),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () => pickTime(context, index + start),
                  child: Text(
                    alarms[index + start].time.format(context),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 242, 249, 40)),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                    scale: .9,
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
                          255, 7, 89, 232), // Thumb color when active
                      activeTrackColor: const Color.fromARGB(
                          255, 184, 212, 225), // Track color when active
                      inactiveThumbColor: const Color.fromARGB(
                          255, 23, 235, 90), // Thumb color when inactive
                      inactiveTrackColor:
                          const Color.fromARGB(255, 216, 229, 215),
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
        second: mosque.isEmpty ? "" : mosque[1]);
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
        saveLocation();
      });
    }
  }
}
