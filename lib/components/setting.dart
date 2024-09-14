import 'package:citizen/pages/emergenacyGuides_page.dart';
import 'package:citizen/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 35, 11),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person, color: Color.fromARGB(255, 219, 180, 39)),
              title: Text('Profile'),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 219, 180, 39)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline_rounded, color: Color.fromARGB(255, 219, 180, 39)),
              title: Text('Emergency Guides'),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 219, 180, 39)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyGuidesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Color.fromARGB(255, 219, 180, 39)),
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
            ListTile(
              leading: Icon(Icons.notifications, color: Color.fromARGB(255, 219, 180, 39)),
              title: Text('Notifications'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode, color: Color.fromARGB(255, 219, 180, 39)),
              title: Text('Dark Mode'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person, color: Color.fromARGB(255, 219, 180, 39)),
              title: Text('Sign Out'),
              trailing: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 219, 180, 39)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 219, 180, 39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
