import 'package:flutter/material.dart';
import 'package:jamatesalat/models/Location.dart';

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
    if (first.text.isNotEmpty || second.text.isNotEmpty) {
      location.first = first.text;
      location.second = second.text;
      debugPrint('Saved note with title: ${location.first}');
      // Optionally, update database here
    }
  }

  @override
  Widget build(BuildContext context) {
    first.text = location.first;
    second.text = location.second;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'NMJammat',
            style: TextStyle(
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
        body: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(100, 300, 100, 00),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: first,
                    onChanged: (value) {
                      debugPrint('First: $value');
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      label: const Text(
                        "First Location",
                        style:
                            TextStyle(color: Color.fromARGB(255, 4, 236, 12)),
                      ),
                      hintText: 'First Mosque',
                    ),
                    style: const TextStyle(
                      color: Colors.white, // Set your desired text color here
                      fontSize: 18.0, // Optionally, set the font size
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: second,
                    onChanged: (value) {
                      debugPrint('second: $value');
                    },
                    decoration: InputDecoration(
                      label: const Text(
                        "Second Location",
                        style:
                            TextStyle(color: Color.fromARGB(255, 4, 236, 12)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Second Mosque',
                    ),
                    style: const TextStyle(
                      color: Colors.white, // Set your desired text color here
                      fontSize: 18.0, // Optionally, set the font size
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
