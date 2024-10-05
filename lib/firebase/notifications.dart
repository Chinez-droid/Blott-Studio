import 'package:blott/auth/legal_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blott/routes/dashboard.dart';
import 'package:blott/providers/notification_preferences.dart';
import 'package:blott/providers/auth_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showBackButton = false;
  late String firstName;

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }

  Future<void> _loadFirstName() async {
    firstName = await AuthPreferences.getFirstName() ?? '';
    setState(() {});
  }

  Future<void> _showCustomNotificationDialog(BuildContext context) async {
    setState(() {
      _showBackButton = true;
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: 270,
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '"Blott" Would Like to Send You Notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.29,
                      letterSpacing: -0.41,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Notifications may include alerts, sounds, and icon badges. These can be configured in Settings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: -0.08,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0x293C3C43), width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Don\'t Allow',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.41,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handleNotificationResponse(context, false);
                          },
                        ),
                      ),
                      Container(
                        width: 0.5,
                        height: 44,
                        color: const Color(0x293C3C43),
                      ),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Allow',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.41,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handleNotificationResponse(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleNotificationResponse(BuildContext context, bool allow) async {
    // Set notification preference without requesting system permission
    await NotificationPreferences.setNotificationsAllowed(allow);
    _showCustomSnackBar(context, allow ? 'Notifications enabled' : 'Notifications disabled', allow);

    // Navigate to the dashboard screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showCustomSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isSuccess ? const Color(0xFF05021C) : const Color(0xFF05021C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Center(
                    child: Image.asset(
                      "assets/images/notif_icon.png",
                      width: 72,
                      height: 72,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Get the most out of Blott ✅',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: Color(0xFF1F2021),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Allow notifications to stay in the loop with your payments, requests and groups.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF737373),
                    ),
                  ),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCustomNotificationDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F39E3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xFFFAFAFA),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            if (_showBackButton)
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LegalNameScreen(),
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: 19,
                    height: 14,
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                      size: 30,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}