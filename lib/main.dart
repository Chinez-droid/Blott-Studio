import 'package:blott/firebase/notifications.dart';
import 'package:blott/providers/notification_preferences.dart';
import 'package:blott/providers/auth_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/legal_name.dart';
import 'routes/dashboard.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationPreferences.init();
  await AuthPreferences.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blott Studio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialScreen(),
      routes: {
        '/legal_name': (context) => const LegalNameScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthPreferences.getFirstName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            // Legal name is set, check if notifications are set up
            return FutureBuilder<bool>(
              future: NotificationPreferences.getNotificationsAllowed(),
              builder: (context, notificationSnapshot) {
                if (notificationSnapshot.connectionState == ConnectionState.done) {
                  // Regardless of the notification preference, navigate to the dashboard
                  return const DashboardScreen();
                }
                // While checking notification preferences, return an empty container
                return const SizedBox.shrink();
              },
            );
          } else {
            // Legal name not set, go to legal name screen
            return const LegalNameScreen();
          }
        }
        // While checking preferences, return an empty container
        return const SizedBox.shrink();
      },
    );
  }
}
