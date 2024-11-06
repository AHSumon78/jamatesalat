import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Location.dart';
import 'package:jamatesalat/models/global_function.dart';
import 'package:geolocator/geolocator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class Locations extends StatefulWidget {
  Location location;
  Locations(this.location, {super.key});
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return LocationsState(location);
  }
}

class LocationsState extends State<Locations> {
  Location location;
  LocationsState(this.location);
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  int timeAx = timeA;
  int timeBx = timeB;
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    saveData(); // Save data before popping
    Navigator.pop(context, location); // Return the updated note
    return Future.value(false); // Prevent default pop
  }

  void saveData() {
    location.first = first.text;
    location.second = second.text;
    debugPrint('Saved note with title: ${location.first}');
    // Optionally, update database here

    location.timeA = timeAx;
    location.timeB = timeBx;
    location.flat = flat;
    location.flong = flong;
    location.slat = slat;
    location.slong = slong;
  }

  @override
  Widget build(BuildContext context) {
    first.text = location.first;
    second.text = location.second;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'NMJammat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: bgColor),
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
            children: <Widget>[
              const SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      "Set Mosque location",
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "Set Distances in time",
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 64, 63, 63),
                thickness: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      maxLength: 10,
                      controller: first,
                      onChanged: (value) {
                        setState(() {
                          location.first = value;
                        });
                        debugPrint('First: $value');
                      },
                      decoration: const InputDecoration(
                        hintText: 'First Mosque',
                      ),
                      style: TextStyle(
                        color: textColor, // Set your desired text color here
                        fontSize: 18.0, // Optionally, set the font size
                      ),
                    ),
                  ),
                  Container(
                    child: NumberPicker(
                      axis: Axis.vertical,
                      value: timeAx,
                      minValue: 0,
                      maxValue: 29,
                      selectedTextStyle:
                          TextStyle(fontSize: 22, color: textColor),
                      textStyle: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 67, 67, 66)),
                      decoration: BoxDecoration(
                        border: Border.all(color: textColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          timeAx = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Text(
                "   latitude    : $flat   Longitude: $flong",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(10),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 142, 207, 234))),
                      onPressed: () async {
                        Position pos = await _getCurrentLocation();
                        setState(() {
                          flat = pos.latitude;
                          flong = pos.longitude;
                        });
                      },
                      child: Text(
                        "Get Current Location",
                        style: TextStyle(color: textColor),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(10),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 142, 207, 234))),
                      onPressed: () async {
                        _OpenMap(flat, flong);
                      },
                      child: Text(
                        "Open google map",
                        style: TextStyle(color: textColor),
                      )),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 42, 42, 42),
                thickness: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      maxLength: 10,
                      controller: second,
                      onChanged: (value) {
                        setState(() {
                          location.second = value;
                        });
                        debugPrint('second: $value');
                      },
                      decoration: const InputDecoration(
                        hintText: 'Second Mosque',
                      ),
                      style: TextStyle(
                        color: textColor, // Set your desired text color here
                        fontSize: 18.0, // Optionally, set the font size
                      ),
                    ),
                  ),
                  Container(
                    child: NumberPicker(
                      axis: Axis.vertical,
                      value: timeBx,
                      minValue: 0,
                      maxValue: 29,
                      selectedTextStyle:
                          TextStyle(fontSize: 22, color: textColor),
                      textStyle: const TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 67, 67, 66)),
                      decoration: BoxDecoration(
                        border: Border.all(color: textColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          timeBx = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              /*  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("   latitude    : $slat\n   Longitude: $slong"),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 161, 160, 160))),
                      onPressed: () async {
                        PickedData newdata = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) =>
                                  PickLocation(),
                            ));
                        setState(() {
                          slat = newdata.latLong.latitude;
                          slong = newdata.latLong.longitude;
                          second = newdata.addressName;
                        });
                      },
                      child: Text(
                        "Pick",
                        style: TextStyle(color: textColor),
                      ))
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _OpenMap(double lat, double long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not lauch $googleURL';
  }
}
