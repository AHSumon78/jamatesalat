import 'package:flutter/material.dart';
import 'package:jamatesalat/screens/first_screen.dart';
import 'package:jamatesalat/utils/notifiaction_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController().initializeNotifications();
  runApp(MyApp());
}
