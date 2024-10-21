import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../components/bottom_bar.dart';
import '../../services/database_service.dart';
import '../map/friends_map.dart';
import '../map/map_page.dart';

class ManageFriendsScreen extends StatefulWidget {
  final String currentPage;

  const ManageFriendsScreen({super.key, this.currentPage = 'friends'});
  @override
  _ManageFriendsScreenState createState() => _ManageFriendsScreenState();
}

class _ManageFriendsScreenState extends State<ManageFriendsScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<DocumentSnapshot> friendsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFriends();
  }

  // Load current user's friends from Firestore
  void loadFriends() async {
    try {
      List<DocumentSnapshot> friends = await _dbService.getFriends();
      setState(() {
        friendsList = friends;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading friends: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to remove a friend from the user's friends list
  void removeFriend(String friendId) async {
    try {
      setState(() {
        isLoading = true; // Show loading while removing friend
      });
      await _dbService.removeFriend(friendId);
      loadFriends(); // Reload friends list after removal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove friend')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Function to show the location of the selected friend
  void showFriendLocation(
      String friendId, String friendName, DocumentSnapshot friendDoc) {
    // Cast friendDoc.data() to a Map<String, dynamic> and check for null
    final Map<String, dynamic>? friendData =
        friendDoc.data() as Map<String, dynamic>?;

    // Check if the data is null or doesn't contain the 'location' key,
    // or if locationSharing is disabled
    if (friendData == null ||
        !friendData.containsKey('location') ||
        friendData['locationSharing'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$friendName has hidden their location'),
        ),
      );
      return;
    }

    // Navigate to EvacuationPlaceMapPage with friendName and evacuationCoords
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendMapPage(
          friendName: friendName,
          userId: friendId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Friends")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 3,
              ),
            )
          : friendsList.isEmpty
              ? _buildEmptyFriendsState()
              : Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: MediaQuery.of(context).size.width *
                        0.05, // 5% horizontal padding
                  ),
                  child: ListView.builder(
                    itemCount: friendsList.length,
                    itemBuilder: (context, index) {
                      var friend = friendsList[index];
                      String friendName = friend['displayName'];
                      String friendId = friend.id;

                      return Card(
                        elevation: 6,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          title: Text(
                            friendName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_horiz,
                                color: Colors.blueAccent), // Modernized Icon
                            onSelected: (String choice) {
                              if (choice == 'Show Location') {
                                // Pass the friend document snapshot to the showFriendLocation function
                                showFriendLocation(
                                    friendId, friendName, friend);
                              } else if (choice == 'Remove Friend') {
                                _showRemoveFriendDialog(friendName, friendId);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'Show Location',
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_pin,
                                          color: Colors.blueAccent),
                                      SizedBox(width: 8),
                                      Text('Show Location'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Remove Friend',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Text('Remove Friend'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }

  // Function to display a dialog before removing a friend
  void _showRemoveFriendDialog(String friendName, String friendId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Remove Friend',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              'Are you sure you want to remove $friendName from your friends?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Remove',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                removeFriend(friendId); // Remove friend
              },
            ),
          ],
        );
      },
    );
  }

  // Enhanced empty state design
  Widget _buildEmptyFriendsState() {
    return SingleChildScrollView(
      // Scrollable if screen height is small
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off,
                size: 80,
                color: Colors.blueAccent
                    .withOpacity(0.7)), // Larger icon, color update
            SizedBox(height: 16), // Spacing
            Text(
              "No friends added yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8), // Additional spacing
            Text(
              "Add some friends to share your adventures!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
