import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

const String uid = 'uid';
const String email = 'email';
const String displayName = 'username';
const String photoURL = 'photoURL';
const String phoneNum = 'phoneNum';
const String createdAt = 'createdAt';
const String address = 'address';
const String status = 'status';

// add latlong location
// add issharing location
// add friends
// add address
class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  // Using a singleton pattern
  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService._();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Public generic method for retrieving data from shared preferences
  dynamic getData(String key) {
    var value = _preferences.get(key);
    print('Retrieved $key: $value');
    return value;
  }

  // Public method for saving data to shared preferences
  void saveData(String key, dynamic value) {
    print('Saving $key: $value');

    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is List<String>) {
      _preferences.setStringList(key, value);
    } else {
      throw Exception('Invalid value type');
    }
  }

  // Method to save user data
  void saveUserData(Map<String, dynamic> userData) {
    userData.forEach((key, value) {
      saveData(key, value);
    });
  }
}
