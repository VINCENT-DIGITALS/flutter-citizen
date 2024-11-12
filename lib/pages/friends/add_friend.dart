import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../components/bottom_bar.dart';
import '../../localization/locales.dart';
import '../../services/database_service.dart';

class AddFriendsScreen extends StatefulWidget {
  final String currentPage;

  const AddFriendsScreen({super.key, this.currentPage = 'friends'});
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  String searchQuery = '';
  List<DocumentSnapshot> searchResults = [];
  final DatabaseService _dbService = DatabaseService();

  // Loading and success states
  Map<String, bool> isLoading = {}; // Tracks loading status for each friend
  Map<String, bool> isSuccess = {}; // Tracks success status for each friend

  void searchUsers(String query) async {
    final results = await _dbService.searchUsers(query);
    setState(() {
      searchResults = results;
    });
  }

  void sendFriendRequest(String friendId) async {
    setState(() {
      isLoading[friendId] = true; // Set loading state to true
    });

    try {
      await _dbService.sendFriendRequest(friendId);

      // Update UI with success message
      setState(() {
        isLoading[friendId] = false;
        isSuccess[friendId] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.friendrequestSuccess.getString(context),)),
      );
    } catch (e) {
      setState(() {
        isLoading[friendId] = false;
        isSuccess[friendId] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request failed!')),
      );
    }
  }

  void confirmFriendRequest(String friendId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleData.sendFriends.getString(context),),
          content: Text(LocaleData.sendFriendsPrompt.getString(context),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(LocaleData.cancel.getString(context),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                sendFriendRequest(friendId); // Proceed with sending the request
              },
              child: Text(LocaleData.send.getString(context),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.addfriends.getString(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                searchUsers(searchQuery);
              },
              decoration: InputDecoration(
                hintText: LocaleData.searchFriends.getString(context),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var user = searchResults[index];
                String userId = user.id;
                bool isUserLoading = isLoading[userId] ?? false;
                bool isRequestSent = isSuccess[userId] ?? false;

                return ListTile(
                  title: Text(user['displayName']),
                  trailing: isUserLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : isRequestSent
                          ? Icon(Icons.check,
                              color: Colors.green) // Success indicator
                          : IconButton(
                              icon: Icon(Icons.person_add),
                              onPressed: () => confirmFriendRequest(
                                  userId), // Confirmation dialog
                            ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }
}
