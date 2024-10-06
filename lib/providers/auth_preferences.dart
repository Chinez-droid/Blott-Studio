import 'package:hive_flutter/hive_flutter.dart';

// Hive local storage for user's names
class AuthPreferences {
  static const String _boxName = 'authBox';
  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Future<void> setFirstName(String firstName) async {
    final box = Hive.box(_boxName);
    await box.put(_firstNameKey, firstName);
  }

  static Future<void> setLastName(String lastName) async {
    final box = Hive.box(_boxName);
    await box.put(_lastNameKey, lastName);
  }

  static Future<String?> getFirstName() async {
    final box = Hive.box(_boxName);
    return box.get(_firstNameKey);
  }

  static Future<String?> getLastName() async {
    final box = Hive.box(_boxName);
    return box.get(_lastNameKey);
  }

  static Future<void> clearAuthData() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}