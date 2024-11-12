import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';
import '../../localization/locales.dart';
import 'add_friend.dart';
import 'friend_page.dart';
import 'manage_friends_page.dart';

class CircleHomePage extends StatefulWidget {
  final String currentPage;

  const CircleHomePage({super.key, this.currentPage = 'friends'});

  @override
  State<CircleHomePage> createState() => _CircleHomePageState();
}

class _CircleHomePageState extends State<CircleHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          LocaleData.friends.getString(context),
        ),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Full-width cards
                children: [
                  // Search and Add Friends
                  FeatureCard(
                    icon: Icons.person_add_alt_1,
                    title: LocaleData.addfriends.getString(context),
                    description: LocaleData.searchnSendfriends.getString(context),
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFriendsScreen(),
                        ),
                      );
                    },
                  ),

                  // Manage Friend Requests
                  FeatureCard(
                    icon: Icons.notifications,
                    title: LocaleData.friendrequest.getString(context),
                    description: LocaleData.friendrequestManage.getString(context),
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendRequestsScreen(),
                        ),
                      );
                    },
                  ),

                  // List of Friends
                  FeatureCard(
                    icon: Icons.group,
                    title: LocaleData.friendList.getString(context),
                    description: LocaleData.friendManage.getString(context),
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageFriendsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color; // Custom color for each icon
  final Function onTap;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color, // New color parameter
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners for modern look
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Colored Icon
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 30,
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
