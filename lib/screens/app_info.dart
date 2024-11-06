import 'package:flutter/material.dart';
import 'package:jamatesalat/models/global_function.dart';

class JamateSalatInfo extends StatelessWidget {
  const JamateSalatInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NMJammat'),
        backgroundColor: bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Mission',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To empower Muslims around the world by providing an accurate and reliable tool to facilitate prayer times and mosque locations, fostering community and spiritual growth.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            Text(
              'Vision',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To become the leading app for Muslims globally, making it easy to stay connected with prayer schedules and nearby mosques, enhancing the experience of Salat through technology.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            Text(
              'Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Prayer Time Notifications\n- Accurate Qibla Finder\n- Mosque Locator\n- Customizable Alerts\n- Community Events\n- Islamic Calendar\n- Dua Library\n- Ad-Free Experience',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
