import 'package:citizen/pages/home_page.dart';
import 'package:citizen/pages/hotlineDirectories_page.dart';
import 'package:citizen/pages/profile_page.dart';
import 'package:citizen/sidebar_Pages/about_app_page.dart';
import 'package:citizen/sidebar_Pages/about_cdrrmo_page.dart';
import 'package:citizen/sidebar_Pages/cpr_page.dart';
import 'package:citizen/sidebar_Pages/fire_safety_tips_page.dart';
import 'package:citizen/sidebar_Pages/first_aid_tips_page.dart';
import 'package:citizen/sidebar_Pages/mental_health_page.dart';
import 'package:citizen/sidebar_Pages/personal_safety.dart';
import 'package:citizen/sidebar_Pages/privacy_policy_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences? _prefs;
  Map<String, String> _userData = {};

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
  }

  @override
  Widget build(BuildContext context) {
    String displayName = _userData['displayName'] ?? 'Guest';
    String firstLetter =
        displayName.isNotEmpty ? displayName.substring(0, 1) : '?';

    // Define orange color for icons
    final Color iconColor = Colors.orange.shade600;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BAYANi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                              fontSize: 28, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Hello, $displayName!",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            _buildSectionTitle("General"),
            _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.location_on,
                text: 'Directories',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotlineDirectoriesPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.info,
                text: 'About CDRRMO',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutCdrrmoPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.privacy_tip,
                text: 'Privacy Policy',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                }),
            const Divider(color: Colors.grey),
            _buildSectionTitle("Emergency Guides"),
            _buildDrawerItem(
                icon: Icons.health_and_safety,
                text: 'First Aid Tips',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstAidTipsPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.fire_extinguisher,
                text: 'Fire Safety Tips',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FireSafetyTipsPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.heart_broken_outlined,
                text: 'CPR',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CprPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.security,
                text: 'Personal Safety',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalSafetyPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.health_and_safety,
                text: 'Mental Health',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MentalHealthPage()),
                  );
                }),
            const Divider(color: Colors.grey),
            _buildSectionTitle("Account"),
            _buildDrawerItem(
                icon: Icons.person,
                text: 'User Profile',
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.people,
                text: 'Friends/Circle',
                iconColor: iconColor,
                onTap: () {}),
            const Divider(color: Colors.grey),
            _buildSectionTitle("App"),
            _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'About App',
                iconColor: iconColor,
                onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AboutAppPage()),
                  );}),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required Color iconColor,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
