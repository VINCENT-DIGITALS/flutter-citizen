import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Add this package to pubspec.yaml
import '../../components/bottom_bar.dart';
import '../../services/database_service.dart';

class FriendRequestsScreen extends StatefulWidget {
  final String currentPage;

  const FriendRequestsScreen({super.key, this.currentPage = 'friends'});
  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final DatabaseService _dbService = DatabaseService();
  bool isProcessing = false; // To handle loading during accept/decline actions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friend Requests")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _dbService.getPendingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoadingList();
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return _buildEmptyState();
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          List<dynamic> pendingRequests = userData['pendingRequests'] ?? [];

          if (pendingRequests.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              String friendId = pendingRequests[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('citizens')
                    .doc(friendId)
                    .get(),
                builder: (context, friendSnapshot) {
                  if (friendSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildShimmerLoadingTile();
                  }

                  if (friendSnapshot.hasError) {
                    return ListTile(
                        title: Text("Error loading friend details"));
                  }

                  if (!friendSnapshot.hasData ||
                      friendSnapshot.data?.data() == null) {
                    return ListTile(title: Text("Friend data not found"));
                  }

                  var friendData =
                      friendSnapshot.data!.data() as Map<String, dynamic>? ??
                          {};
                  String friendName = friendData['displayName'] ?? 'Unknown';

                  return ListTile(
                    title: Text(friendName),
                    trailing: isProcessing
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () =>
                                    _handleFriendRequest(friendId, true),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: const Color.fromARGB(255, 108, 244, 54)),
                                onPressed: () =>
                                    _handleFriendRequest(friendId, false),
                              ),
                            ],
                          ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }

  // Shimmer effect for loading list
  Widget _buildShimmerLoadingList() {
    return ListView.builder(
      itemCount: 5, // Simulate 5 loading items
      itemBuilder: (context, index) {
        return _buildShimmerLoadingTile();
      },
    );
  }

  // Shimmer effect for loading tile
  Widget _buildShimmerLoadingTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        title: Container(
          height: 20,
          width: 150,
          color: Colors.grey[300],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              color: Colors.grey[300],
            ),
            SizedBox(width: 10),
            Container(
              height: 20,
              width: 20,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // Empty state with better design
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No pending friend requests",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Error state with better design
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Error loading friend requests",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }

  // Handle friend request (accept/decline)
  void _handleFriendRequest(String friendId, bool isAccepted) async {
    setState(() {
      isProcessing = true;
    });

    try {
      if (isAccepted) {
        await _dbService.acceptFriendRequest(friendId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Friend request accepted"),
          backgroundColor: Colors.green,
        ));
      } else {
        await _dbService.declineFriendRequest(friendId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Friend request declined"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to process request"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }
}
