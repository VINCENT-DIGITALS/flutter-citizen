import 'package:flutter/material.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';
import 'add_friend.dart';
import 'friend_page.dart';
import 'friends_map.dart';
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
      appBar: AppBar(
        title: Text('Friend Circle Home'),
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
                    title: 'Add Friends',
                    description: 'Search and send friend requests',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFriendsScreen()),
                      );
                    },
                  ),

                  // View Friends on Map
                  FeatureCard(
                    icon: Icons.map,
                    title: 'View on Map',
                    description: 'See friends\' locations on the map',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendsMapScreen()),
                      );
                    },
                  ),

                  // Manage Friend Requests
                  FeatureCard(
                    icon: Icons.notifications,
                    title: 'Friend Requests',
                    description: 'View and manage friend requests',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendRequestsScreen()),
                      );
                    },
                  ),

                  // List of Friends
                  FeatureCard(
                    icon: Icons.group,
                    title: 'List of Friends',
                    description: 'View and manage friends',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageFriendsScreen()), // Updated to ManageFriendsScreen
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
  final Function onTap;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18)),
                    SizedBox(height: 4),
                    Text(description, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
