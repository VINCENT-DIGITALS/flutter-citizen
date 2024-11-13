import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../localization/locales.dart';
import '../../services/database_service.dart';
import '../announcement_detail_page.dart';

final PageController _announcementsPageController = PageController();
final DatabaseService _dbService = DatabaseService();
Widget buildAnnouncements(BuildContext context) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: _dbService.getLatestItemsStream('announcements'),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error fetching announcements'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No announcements available'));
      }

      List<Map<String, dynamic>> announcements = snapshot.data!;

      return Container(
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 219, 219, 219),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                LocaleData.announcements.getString(context),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _announcementsPageController,
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return _buildAnnouncementCard(context, announcements[index]);
                },
              ),
            ),
            SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _announcementsPageController,
              count: announcements.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 16,
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildAnnouncementCard(
    BuildContext context, Map<String, dynamic> announcement) {
  DateTime timestamp = (announcement['timestamp'] as Timestamp).toDate();
  String formattedDate = DateFormat('MMMM d, yyyy h:mm a').format(timestamp);

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnnouncementDetailPage(
            announcement: announcement,
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement['title'] ?? 'Announcement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1, // Limits to 1 line
            overflow:
                TextOverflow.ellipsis, // Adds ellipsis if text is too long
          ),
          SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 12),
          Text(
            announcement['content'] ??
                'Please fill in the fields and enable location services for accurate tracking. Video uploads are limited to 5 seconds.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            maxLines: 3, // Limits to 3 lines
            overflow:
                TextOverflow.ellipsis, // Adds ellipsis if text is too long
          ),
        ],
      ),
    ),
  );
}
