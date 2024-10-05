import 'package:hive/hive.dart';

class NotificationPreferences {
  static const String _boxName = 'notificationPreferences';
  static const String _allowedKey = 'notificationsAllowed';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Future<void> setNotificationsAllowed(bool allowed) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_allowedKey, allowed);
  }

  static Future<bool> getNotificationsAllowed() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_allowedKey, defaultValue: false);
  }
}