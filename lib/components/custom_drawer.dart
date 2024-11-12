import 'package:citizen/localization/locales.dart';
import 'package:citizen/pages/home_page.dart';
import 'package:citizen/pages/hotlineDirectories_page.dart';
import 'package:citizen/pages/post_page.dart';
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
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../pages/emergenacyGuides_page.dart';
import '../pages/friends/friends_circle_page.dart';
import '../services/database_service.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final DatabaseService _dbService = DatabaseService();
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
                      Expanded(
                        child: AutoSizeText(
                          LocaleData.hello
                              .getString(context)
                              .replaceAll('%s', displayName),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          maxLines: 2,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            _buildSectionTitle(
              LocaleData.general.getString(context),
            ),
            _buildDrawerItem(
                icon: Icons.home,
                text:  LocaleData.home
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }),
            // _buildDrawerItem(
            //     icon: Icons.home,
            //     text: 'Post',
            //     iconColor: iconColor,
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => const PostsPage()),
            //       );
            //     }),
            _buildDrawerItem(
                icon: Icons.location_on,
                text: LocaleData.hotlineDirectories
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotlineDirectoriesPage()),
                  );
                }),

            const Divider(color: Colors.grey),
            _buildSectionTitle(LocaleData.emergencyGuides
                              .getString(context),),
            _buildDrawerItem(
                icon: Icons.health_and_safety,
                text: LocaleData.firstAidTips
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstAidTipsPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.fire_extinguisher,
                text: LocaleData.fireSafetyTips
                              .getString(context),
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
                text: LocaleData.cPR
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CprPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.security,
                text: LocaleData.personalSafety
                              .getString(context),
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
                text: LocaleData.mentalHealth
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MentalHealthPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.more_horiz_outlined,
                text: LocaleData.moreGuides
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmergencyGuidesPage()),
                  );
                }),
            const Divider(color: Colors.grey),
            _buildSectionTitle(LocaleData.account
                              .getString(context),),
            _buildDrawerItem(
                icon: Icons.person,
                text: LocaleData.userProfile
                              .getString(context),
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
                text: LocaleData.friendsCircle
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  // Check if user is logged in
                  if (_dbService.isAuthenticated()) {
                    // If logged in, navigate to Friends/Circle page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CircleHomePage()),
                    );
                  } else {
                    // If not logged in, redirect to login page
                    _dbService.redirectToLogin(context);
                  }
                }),
            const Divider(color: Colors.grey),

            _buildSectionTitle(LocaleData.app
                              .getString(context),),
            _buildDrawerItem(
                icon: Icons.info,
                text: LocaleData.aboutCDRRMO
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutCdrrmoPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.privacy_tip,
                text: LocaleData.privacyPolicy
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                }),
            _buildDrawerItem(
                icon: Icons.info_outline,
                text: LocaleData.aboutApp
                              .getString(context),
                iconColor: iconColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutAppPage()),
                  );
                }),
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
