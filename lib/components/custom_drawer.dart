import 'package:citizen/components/setting.dart';
import 'package:citizen/main.dart';
import 'package:citizen/pages/map_page.dart';
import 'package:citizen/services/auth_page.dart';
import 'package:citizen/pages/home_page.dart';
import 'package:citizen/pages/login_page.dart';
import 'package:citizen/pages/profile_page.dart';
import 'package:citizen/pages/weather_page.dart';
import 'package:citizen/services/database_service.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences? _prefs;
  final DatabaseService _dbService = DatabaseService();
  bool _isSettingExpanded = false;
  Map<String, String> _userData= {};

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

   void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _fetchAndDisplayUserData();
  }
    Future<void> _fetchAndDisplayUserData() async {
    try {
      setState(() {
        _userData = {
          'uid': _prefs?.getString('uid') ?? '',
          'email': _prefs?.getString('email') ?? '',
          'displayName': _prefs?.getString('displayName') ?? '',
          'photoURL': _prefs?.getString('photoURL') ?? '',
          'phoneNum': _prefs?.getString('phoneNum') ?? '',
          'createdAt': _prefs?.getString('createdAt') ?? '',
          'address': _prefs?.getString('address') ?? '',
          'status': _prefs?.getString('status') ?? '',
        };
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void signUserOut(BuildContext context) {
    _dbService.signOut().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }).catchError((error) {
      print("Sign out failed: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    
    User? user = _dbService.currentUser;
    bool isLoggedIn = user != null;
    String firstLetter = _userData['displayName']?.isNotEmpty == true ? _userData['displayName']!.substring(0, 1) : '';
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromRGBO(219, 180, 39, 1), Colors.blue.shade400],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Text(
                      firstLetter.isEmpty ? '?' : firstLetter, // Initials or image can be added here
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _userData['displayName'] ?? ' ', // Assuming 'displayName' field exists
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny, color: Colors.white),
              title: const Text('Weather', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.white),
              title: const Text('Map', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
            ),
            if (isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Setting', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SettingsWidget(),
                    );
                  },
                );
                },
              ),
            ],
            const Divider(color: Colors.white),
            if (isLoggedIn)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                onTap: () {
                  signUserOut(context);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.login, color: Colors.white),
                title: const Text('Sign In', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
