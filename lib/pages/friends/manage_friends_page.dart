import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class ManageFriendsScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Friends')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : friendsList.isEmpty
              ? _buildEmptyFriendsState() // Show enhanced empty state
              : ListView.builder(
                  itemCount: friendsList.length,
                  itemBuilder: (context, index) {
                    var friend = friendsList[index];
                    String friendName = friend['displayName'];
                    String friendId = friend.id;

                    return ListTile(
                      title: Text(friendName),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Remove Friend'),
                                content: Text('Are you sure you want to remove $friendName from your friends?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Remove', style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      removeFriend(friendId); // Remove friend
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  // Build the enhanced empty state with icon and message
  Widget _buildEmptyFriendsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.grey), // Icon
          SizedBox(height: 16), // Spacing
          Text(
            "No friends added",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
