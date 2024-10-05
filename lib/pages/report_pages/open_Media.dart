import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatefulWidget {
  final String? mediaUrl;

  const MediaWidget({Key? key, required this.mediaUrl}) : super(key: key);

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();

    if (widget.mediaUrl != null && _isVideo(widget.mediaUrl!)) {
      _videoController = VideoPlayerController.network(widget.mediaUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaUrl == null) {
      return const Text('No media available');
    } else if (_isVideo(widget.mediaUrl!)) {
      return _videoController != null && _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : const CircularProgressIndicator();
    } else {
      // For images, display the image with click-to-open-fullscreen functionality
      return GestureDetector(
        onTap: () {
          setState(() {
            _isFullScreen = true; // Set full screen when tapped
          });
          _openFullScreenImage(context);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            widget.mediaUrl!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  bool _isVideo(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm');
  }

  // Full-screen image display logic
  void _openFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.network(widget.mediaUrl!, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30.0),
                  onPressed: () {
                    Navigator.pop(context); // Close full-screen image
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _isFullScreen = false;
      });
    });
  }
}
