import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDeveloper extends StatelessWidget {
  const ContactDeveloper({super.key});

  Future<void> _openMailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '', // Empty path opens the Mail app
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Mail App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("mmdsumonali@gmail.com"),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _openMailApp,
              child: const Text('Open Mail App'),
            ),
          ),
        ],
      ),
    );
  }
}
