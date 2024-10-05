import 'package:citizen/pages/emergenacyGuides_page.dart';
import 'package:citizen/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../services/database_service.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _locationBasedServicesEnabled = true;
  bool _emergencyAlertsEnabled = true;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = 'en'; // Set a default value
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale') ?? 'en';
    setState(() {
      _currentLocale = locale;
    });
    _flutterLocalization.translate(locale);
  }

  Future<void> _setLocale(String? value) async {
    if (value == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
    setState(() {
      _currentLocale = value;
    });
    _flutterLocalization.translate(value);
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

            // ListTile(
            //   leading: Icon(Icons.help_outline_rounded, color: Colors.orange),
            //   title: Text('Emergency Guides'),
            //   trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
            //   onTap: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => EmergencyGuidesPage()),
            //     );
            //   },
            // ),

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
