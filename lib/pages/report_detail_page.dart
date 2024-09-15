import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart'; // Add video player package

class ReportDetailPage extends StatefulWidget {
  final Map<String, dynamic> report;

  const ReportDetailPage({required this.report});

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool _isMediaOpened = false;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose the video controller when not needed
    super.dispose();
  }

  // Convert Firestore Timestamp to formatted DateTime string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A'; // Return 'N/A' if timestamp is null
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a')
        .format(dateTime); // Format the DateTime
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final String? mediaUrl = report['mediaUrl'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incident Type: ${report['incidentType'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Formatting the Timestamp value here
            _buildDetailRow(
                'Date & Time',
                _formatTimestamp(
                    report['timestamp']) // Format the timestamp value
                ),
            _buildDetailRow(
                'No. of Injured', report['injuredCount']?.toString() ?? 'N/A'),
            _buildDetailRow('Severity', report['seriousness'] ?? 'N/A'),
            _buildDetailRow('Location', report['address'] ?? 'N/A'),
            _buildDetailRow('Landmark', report['landmark'] ?? 'N/A'),
            _buildDetailRow('Description', report['description'] ?? 'N/A'),
            const SizedBox(height: 16),

            // Media Section: Button to load media
            if (!_isMediaOpened)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isMediaOpened = true;
                      if (mediaUrl != null && _isVideo(mediaUrl)) {
                        _videoController =
                            VideoPlayerController.network(mediaUrl)
                              ..initialize().then((_) {
                                setState(
                                    () {}); // To refresh UI after video initializes
                              });
                      }
                    });
                  },
                  child: const Text('Tap to Open Media'),
                ),
              )
            else
              _buildMediaWidget(mediaUrl),

            const SizedBox(height: 16),

            // Expand Map Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add logic to open the map in a detailed view
                },
                child: const Text('Expand Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaWidget(String? mediaUrl) {
    if (mediaUrl == null) {
      return const Text('No media available');
    } else if (_isVideo(mediaUrl)) {
      // Handle Video Media
      return _videoController != null && _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : const CircularProgressIndicator(); // Show loading indicator while video is initializing
    } else {
      // Handle Image Media
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
    // Simple check for video formats (can be improved based on actual URLs)
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm');
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
