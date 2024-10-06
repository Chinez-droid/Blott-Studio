import 'package:blott/services/notifications.dart';
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
            // Legal name is set, check if notifications preference is set
            return FutureBuilder<bool?>(
              future: NotificationPreferences.getNotificationsAllowed(),
              builder: (context, notificationSnapshot) {
                if (notificationSnapshot.connectionState ==
                    ConnectionState.done) {
                  if (notificationSnapshot.data != null) {
                    // Notification preference is set (either true or false), go to dashboard
                    return const DashboardScreen();
                  } else {
                    // Notification preference not set, go to notifications screen
                    return const NotificationsScreen();
                  }
                }
                // While checking notification preferences, show circular progress indicator
                return const CircularProgressIndicator();
              },
            );
          } else {
            // Legal name not set, go to legal name screen
            return const LegalNameScreen();
          }
        }
        // While checking preferences, show circular progress indicator
        return const Scaffold(
          backgroundColor: Color(0xFF000000),
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      },
    );
  }
}