import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

class AnnouncementDetailPage extends StatelessWidget {
  final Map<String, dynamic> announcement;

  AnnouncementDetailPage({required this.announcement});

  // Convert Firestore Timestamp to formatted DateTime string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A'; // Return 'N/A' if timestamp is null
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a').format(dateTime); // Format the DateTime
  }

  // Method to share the announcement
  void _shareAnnouncement() {
    final String title = announcement['title'] ?? 'No Title';
    final String content = announcement['content'] ?? 'No Description';
    final String timestamp = _formatTimestamp(announcement['timestamp']);
    
    // Construct the share message
    final String shareMessage = '$title\n\n$content\n\nPublished on: $timestamp';
    
    // Share the message using share_plus
    Share.share(shareMessage, subject: 'Check out this announcement!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          announcement['title'] ?? 'Announcement Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        shadowColor: Colors.black,
        elevation: 2.0,
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Card(
          elevation: 3, // Adds a slight shadow effect to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement['title'] ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Divider(color: Colors.grey[300]), // Divider between title and timestamp
                SizedBox(height: 8),
                Text(
                  _formatTimestamp(announcement['timestamp']),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic, // Italicized timestamp
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey[300]), // Divider between timestamp and content
                SizedBox(height: 20),
                Text(
                  announcement['content'] ?? 'No Description',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5, // Increased line height for readability
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey[300]), // Divider at the bottom
                SizedBox(height: 10),
                // Wrap for responsive layout
                Wrap(
                  spacing: 10, // Space between buttons
                  alignment: WrapAlignment.end, // Align buttons to the end
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.orange),
                      onPressed: _shareAnnouncement, // Call share method
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Light background for contrast
    );
  }
}
