import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';

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
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
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
                      _buildDetailRow(
                      Icons.description_outlined, 'Description', reportData['description']),
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
                      onPressed: () {
                        setState(() {
                          _isMediaOpened = true;
                          if (mediaUrl != null && _isVideo(mediaUrl)) {
                            _videoController =
                                VideoPlayerController.network(mediaUrl)
                                  ..initialize().then((_) => setState(() {}));
                          }
                        });
                      },
                      icon: const Icon(Icons.play_circle, color: Colors.white),
                      label: const Text('Open Media', style: TextStyle(color: Colors.white),),
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
                      setState(() {
                        _isMapExpanded = !_isMapExpanded;
                      });
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text('Toggle Map', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                if (_isMapExpanded && reportLocation != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 300,
                        child: _buildMapWidget(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
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

  Widget _buildMapWidget() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: reportLocation ?? LatLng(15.7140846, 120.9001115),
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }

  Widget _buildMediaWidget(String? mediaUrl) {
    if (mediaUrl == null) {
      return const Text('No media available');
    } else if (_isVideo(mediaUrl)) {
      return _videoController != null && _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : const CircularProgressIndicator();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          mediaUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  bool _isVideo(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm');
  }
}
