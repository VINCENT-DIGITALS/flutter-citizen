import 'package:flutter/material.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String announcement;

  AnnouncementDetailScreen({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcement Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              announcement,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
