import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDeveloper extends StatelessWidget {
  const ContactDeveloper({super.key});

  Future<void> _openMailApp() async {
    String mailURL =
        'https://mail.google.com/mail/u/0/#inbox?compose=jrjtXFBjnwWHSPpptmpSsKpzXlVPwSvZQfXJtlFNWTzZpjHtMGRwjKnTnKZQFzLftsWpQCph';
    await canLaunchUrlString(mailURL)
        ? await launchUrlString(mailURL)
        : throw 'Could not lauch $mailURL';
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
