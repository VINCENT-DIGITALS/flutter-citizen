import 'package:citizen/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // For calculating distances
import 'package:intl/intl.dart'; // For timestamp formatting
import 'package:logger/logger.dart';

import '../main.dart';
import '../pages/report_pages/summary_report_page.dart';
import 'location_service.dart';

class FirestoreListenerService {
  Timestamp? lastDocumentTimestamp;
  final LocationService _locationService = LocationService();
  final Logger _logger = Logger(); // Use Logger for better error logging.
  Position? _currentPosition;
  static final FirestoreListenerService _instance =
      FirestoreListenerService._internal();
  factory FirestoreListenerService() {
    return _instance;
  }
  String? userId;
  String? displayName;
  FirestoreListenerService._internal();

  void initialize() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.w(
          'User is not logged in. Firestore listener will not be initialized.');
      return;
    }
    userId = user.uid;
    displayName = user.displayName;
    _listenToReports();
    _fetchCurrentLocation();
  }

  void _listenToReports() {
    FirebaseFirestore.instance
        .collection('reports')
        .where('reporterId', isEqualTo: userId) // Filter by reporterId
        .snapshots()
        .listen(
      (snapshot) {
        for (var change in snapshot.docChanges) {
          final docData = change.doc.data() as Map<String, dynamic>?;

          if (change.type == DocumentChangeType.modified) {
            // Check if the acceptedBy field was added
            if (docData != null && docData.containsKey('acceptedBy')) {
              _logger
                  .i('AcceptedBy field detected for document ${change.doc.id}');
              _showNewReportDialog(docData);
            }
          }
        }
      },
      onError: (e) => _logger.e('Error listening to reports: $e'),
    );
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      _currentPosition = await _locationService.requestLocation();
    } catch (e) {
      _logger.e('Error fetching location: $e');
    }
  }

  Future<void> _showNewReportDialog(Map<String, dynamic>? data) async {
    final context = navigatorKey.currentState?.context;
    if (context == null) {
      _logger.w('Context is null; cannot show dialog.');
      return;
    }
    if (data == null) return;

    // Calculate distance
    double? distance = _calculateDistance(data['location']);

    // Get acceptedBy value
    String acceptedBy = data['acceptedBy'] ?? 'Not yet accepted';

    // Build and show dialog
    showDialog(
      context: context,
      builder: (context) =>
          _buildReportDialog(context, data, distance, acceptedBy),
    );
  }

  double? _calculateDistance(GeoPoint? location) {
    if (_currentPosition == null || location == null) return null;

    final Distance distanceCalculator = Distance();
    final LatLng currentLocation =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final LatLng reportLocation = LatLng(location.latitude, location.longitude);

    return distanceCalculator.as(
        LengthUnit.Kilometer, currentLocation, reportLocation);
  }

  Widget _buildReportDialog(BuildContext context, Map<String, dynamic> data,
      double? distance, String acceptedBy) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.report, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '${displayName}, your report has been accepted by ${acceptedBy}!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.justify, // Justify the text here
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Accepted time', _formatTimestamp(data['updatedAt'])),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog first
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ReportsSummaryPage(currentPage: 'SummaryReport'),
              ),
            );
          },
          child: Text('View Reports'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    // Default row for other details
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }
}
