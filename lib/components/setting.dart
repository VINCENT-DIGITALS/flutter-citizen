import 'package:citizen/pages/emergenacyGuides_page.dart';
import 'package:citizen/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../services/database_service.dart';
import '../services/foreground_service.dart';
import '../services/location_service.dart';
import '../services/notificatoin_service.dart';
import '../services/shared_pref.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  // bool _isDarkMode = false;
  bool _isNotificationEnabled = false;
  // bool _locationBasedServicesEnabled = true;
  // bool _emergencyAlertsEnabled = true;
  bool _isLocationSharingEnabled = false; // Location sharing state

  final DatabaseService _dbService = DatabaseService();
  final MyForegroundService _foregroundService =
      MyForegroundService(); // Foreground service
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService =
      NotificationService(); // Instantiate NotificationService

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = 'en'; // Set a default value
    _loadLocale();
    _loadLocationSharingStateFromDB(); // Load the location sharing state from the database
    _notificationService.initialize();
    _loadNotificationPermissionStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNotificationPermissionStatus();
  }

  // Check if notification permissions are granted and update the toggle accordingly
  Future<void> _loadNotificationPermissionStatus() async {
    bool hasPermission =
        await NotificationService().hasNotificationPermission();
    setState(() {
      _isNotificationEnabled = hasPermission;
    });
  }

// Handle toggle switch
  Future<void> _toggleNotification(bool isEnabled) async {
    if (isEnabled) {
      // Request permission when enabling notifications
      bool granted = await _notificationService.requestNotificationPermission();
      setState(() {
        _isNotificationEnabled = granted;
      });
      if (!granted) {
        // Show an alert if permission is denied
        _showPermissionDeniedDialog();
      }
    } else {
      // When disabling notifications, show a confirmation dialog
      _showDisableNotificationDialog();
      setState(() {
        _isNotificationEnabled = false;
      });
    }
  }

// Alert when permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied'),
          content: Text(
              'Notifications are disabled. Please enable them in the app settings.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Show a dialog when disabling notifications
  void _showDisableNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disable Notifications'),
          content: Text('To disbale it in app permissions.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Load locale from SharedPreferences using SharedPreferencesService
  Future<void> _loadLocale() async {
    SharedPreferencesService prefsService =
        await SharedPreferencesService.getInstance();
    String? locale =
        prefsService.getData('locale') ?? 'en'; // Retrieve the locale
    setState(() {
      _currentLocale = locale!;
    });
    _flutterLocalization.translate(locale!);
  }

// Save locale using SharedPreferencesService
  Future<void> _setLocale(String? value) async {
    if (value == null) return;
    SharedPreferencesService prefsService =
        await SharedPreferencesService.getInstance();
    prefsService.saveData('locale', value); // Save the locale
    setState(() {
      _currentLocale = value;
    });
    _flutterLocalization.translate(value);
  }

  // Load location sharing state from the database
  Future<void> _loadLocationSharingStateFromDB() async {
    try {
      // Fetch the user document from Firestore using the method from DatabaseService
      Map<String, dynamic>? userData = await _dbService.getDocument('citizens');

      if (userData != null && userData.containsKey('locationSharing')) {
        setState(() {
          _isLocationSharingEnabled = userData['locationSharing'] as bool;
        });
      } else {
        print("Location sharing value not found in database.");
      }
    } catch (e) {
      print("Error loading location sharing state from database: $e");
    }
  }

// Save location sharing state to preferences using SharedPreferencesService
  Future<void> _setLocationSharingState(bool value) async {
    SharedPreferencesService prefsService =
        await SharedPreferencesService.getInstance();
    prefsService.saveLocationSharing(
        value); // Use the method from SharedPreferencesService
  }

// Toggle location sharing
  Future<void> _toggleLocationSharing(bool value) async {
    setState(() {
      _isLocationSharingEnabled = value;
    });

    await _setLocationSharingState(value);

    if (value) {
      // Start the foreground service to track location
      await _foregroundService.startForegroundService();

      // Manually update Firestore with locationSharing = true when toggling on
      try {
        // Ensure location permissions are granted
        bool hasPermission =
            await _locationService.checkLocationServicesAndPermissions();
        if (hasPermission) {
          Position position = await _locationService.getCurrentLocation();
          GeoPoint location = GeoPoint(position.latitude, position.longitude);

          // Directly update Firestore with location and locationSharing = true
          await _dbService.updateLocationSharing(
            location: location,
            locationSharing: true, // Set locationSharing to true here
          );
        }
      } catch (e) {
        print('Error updating Firestore when enabling location sharing: $e');
      }
    } else {
      // Stop the foreground service and update location sharing to false
      await _foregroundService.stopForegroundService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 15, 35, 11),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Profile Navigation
            ListTile(
              leading: Icon(Icons.person, color: Colors.orange),
              title: Text('Profile'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),

            // Language Dropdown
            ListTile(
              leading: Icon(Icons.language, color: Colors.orange),
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: _currentLocale,
                items: const [
                  DropdownMenuItem(
                    value: "en",
                    child: Text("English"),
                  ),
                  DropdownMenuItem(
                    value: "tl",
                    child: Text("Tagalog"),
                  ),
                ],
                onChanged: (value) {
                  _setLocale(value);
                },
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SwitchListTile(
                  activeColor: Colors.orange,
                  title: Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.orange),
                      SizedBox(
                          width: constraints.maxWidth *
                              0.02), // Responsive spacing
                      Flexible(
                        child: Text(
                          'Enable Notifications',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width *
                                0.04, // Responsive text size
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: _isNotificationEnabled,
                  onChanged: (bool value) {
                    _toggleNotification(value);
                  },
                );
              },
            ),

            // Show Location Sharing Toggle only if the user is authenticated
            if (_dbService
                .isAuthenticated()) // Check if the user is authenticated
              LayoutBuilder(
                builder: (context, constraints) {
                  return SwitchListTile(
                    activeColor: Colors.orange,
                    title: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.orange),
                        SizedBox(
                            width: constraints.maxWidth *
                                0.02), // Responsive spacing
                        Flexible(
                          child: Text(
                            'Location Sharing',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.04, // Responsive text size
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: _isLocationSharingEnabled,
                    onChanged: (bool value) {
                      _toggleLocationSharing(value);
                    },
                  );
                },
              ),

            // Conditional Login/Logout Button
            Center(
              child: _dbService.isAuthenticated()
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () async {
                        try {
                          await _dbService.signOut();
                          Navigator.of(context).pop();
                        } catch (e) {
                          print('Logout failed: $e');
                        }
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text('Log out',
                          style: TextStyle(color: Colors.white)),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                      ),
                      onPressed: () {
                        // Navigate to the login screen
                        _dbService.redirectToLogin(context);
                      },
                      icon: Icon(Icons.login, color: Colors.white),
                      label:
                          Text('Login', style: TextStyle(color: Colors.white)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
