import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Location.dart';
import 'package:jamatesalat/models/global_function.dart';

import 'package:numberpicker/numberpicker.dart';

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
              /*  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("   latitude    : $flat\n   Longitude: $flong"),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 133, 132, 132))),
                      onPressed: () async {
                        PickedData newdata = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickLocation(),
                            ));
                        setState(() {
                          flat = newdata.latLong.latitude;
                          flong = newdata.latLong.longitude;
                          first = newdata.addressName;
                        });
                      },
                      child: Text(
                        "Pick",
                        style: TextStyle(color: textColor),
                      ))
                ],
              ),*/
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
}
