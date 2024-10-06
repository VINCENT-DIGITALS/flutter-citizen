import 'package:shared_preferences/shared_preferences.dart';

const String uid = 'uid';
const String email = 'email';
const String displayName = 'username';
const String photoURL = 'photoURL';
const String phoneNum = 'phoneNum';
const String createdAt = 'createdAt';
const String address = 'address';
const String status = 'status';
const String latitude = 'latitude';
const String longitude = 'longitude';
const String isSharingLocation = 'isSharingLocation';
const String friends = 'friends'; // A list of friend IDs or names

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  // Singleton pattern
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

  // Method to save latitude and longitude
  void saveLocation(double lat, double lon) {
    saveData(latitude, lat);
    saveData(longitude, lon);
  }

  // Method to save location-sharing state
  void saveLocationSharing(bool isSharing) {
    saveData(isSharingLocation, isSharing);
  }

  // Method to save friends list
  void saveFriends(List<String> friendsList) {
    saveData(friends, friendsList);
  }

  // Method to retrieve friends list
  List<String> getFriends() {
    return _preferences.getStringList(friends) ?? [];
  }
}
