import 'package:flutter/material.dart';
import 'app/app_widget.dart';
import 'core/services/firebase_service.dart';
import 'core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FirebaseService.initialize();
  await NotificationService.initialize();

  runApp(const StudyMapApp());
}
