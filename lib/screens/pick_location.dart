import 'package:flutter/material.dart';
import 'package:jamatesalat/models/global_function.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class PickLocation extends StatefulWidget {
  final LatLong latLong;
  PickLocation({required this.latLong});
  @override
  State<PickLocation> createState() => PickLocationState();
}

class PickLocationState extends State<PickLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Find Mosque Location"),
          backgroundColor: bgColor,
        ),
        body: OpenStreetMapSearchAndPick(
          buttonTextStyle:
              const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
          buttonColor: const Color.fromARGB(255, 159, 166, 172),
          buttonText: 'Set Mosque Location',
          onPicked: (pickedData) {
            Navigator.pop(context, pickedData.latLong);
          },
        ));
  }
}
//Rajshahi
