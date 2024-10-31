import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';
import '../map/report_map.dart';

class ReportDetailPage extends StatefulWidget {
  final String reportId;
  final String currentPage;
  const ReportDetailPage(
      {Key? key, required this.reportId, this.currentPage = 'SummaryReport'})
      : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VideoPlayerController? _videoController;
  bool _isMediaOpened = false;
  bool _isMapExpanded = false;

  LatLng? reportLocation;
  final MapController mapController = MapController();

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Incident Reports'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('reports').doc(widget.reportId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Report not found.'));
          }

          final reportData = snapshot.data!.data() as Map<String, dynamic>;
          final GeoPoint? location = reportData['location'];
          if (location != null) {
            reportLocation = LatLng(location.latitude, location.longitude);
          }
          final String? mediaUrl = reportData['mediaUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Incident Information'),
                _buildDetailCard([
                  _buildDetailRow(
                      Icons.report, 'Type', reportData['incidentType']),
                  _buildDetailRow(Icons.access_time, 'Date & Time',
                      _formatTimestamp(reportData['timestamp'])),
                  _buildDetailRow(Icons.person, 'No. of Injured',
                      reportData['injuredCount']?.toString() ?? 'N/A'),
                  _buildDetailRow(
                      Icons.warning, 'Severity', reportData['seriousness']),
                  _buildDetailRow(Icons.description_outlined, 'Description',
                      reportData['description']),
                ]),
                const SizedBox(height: 16),
                _buildSectionHeader('Location Details'),
                _buildDetailCard([
                  _buildDetailRow(
                      Icons.place, 'Address', reportData['address']),
                  _buildDetailRow(
                      Icons.location_on, 'Landmark', reportData['landmark']),
                ]),
                const SizedBox(height: 16),
                _buildSectionHeader('Report Status'),
                _buildDetailCard([
                  _buildDetailRow(Icons.person_search, 'Accepted By',
                      reportData['acceptedBy'] ?? 'Pending'),
                  _buildDetailRow(Icons.update, 'Status',
                      reportData['status'] ?? 'Pending'),
                ]),
                const SizedBox(height: 16),
                if (!_isMediaOpened)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final shouldOpen = await _showConfirmationDialog(
                            context,
                            "Open Media",
                            "Are you sure you want to open the media?");
                        if (shouldOpen) {
                          setState(() {
                            _isMediaOpened = true;
                          });
                          if (mediaUrl != null && _isVideo(mediaUrl)) {
                            _videoController =
                                VideoPlayerController.network(mediaUrl)
                                  ..initialize().then((_) => setState(() {}));
                          } else if (mediaUrl != null) {
                            final uri = Uri.parse(mediaUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              print('Could not launch $mediaUrl');
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.play_circle, color: Colors.white),
                      label: const Text(
                        'Open Media',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                else
                  _buildMediaWidget(mediaUrl),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Check if the location is a GeoPoint, then convert to LatLng
                      if (reportData['location'] is GeoPoint) {
                        GeoPoint geoPoint = reportData['location'];
                        LatLng location =
                            LatLng(geoPoint.latitude, geoPoint.longitude);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportMapPage(
                              locationName: reportData['address'],
                              resportCoords: location, // Pass the LatLng object
                              responderId:
                                  reportData['responderId'], // May be null
                              reportStatus: reportData['status'], // May be null
                            ),
                          ),
                        );
                      } else {
                        // Handle error if location is not a GeoPoint (optional)
                        print('Location is not a GeoPoint');
                      }
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text('View Map',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text("Confirm"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaWidget(String? mediaUrl) {
    if (mediaUrl == null) {
      return const Text('No media available');
    }

    if (!_isImage(mediaUrl)) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(mediaUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              print('Could not launch $mediaUrl');
            }
          },
          icon: const Icon(Icons.open_in_new, color: Colors.white),
          label: const Text(
            'Open Media',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          mediaUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text('Error loading image');
          },
        ),
      );
    }
  }

// Helper function to check if the URL is an image
  bool _isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  bool _isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.webm', '.avi', '.mkv', '.flv'];
    return videoExtensions
        .any((extension) => url.toLowerCase().endsWith(extension));
  }
}
