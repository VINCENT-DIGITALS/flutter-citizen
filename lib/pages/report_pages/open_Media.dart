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

    if (widget.mediaUrl != null) {
      // Initialize video controller if media URL appears to be a video or fallback
      if (_isVideo(widget.mediaUrl!)) {
        _initializeVideoPlayer(widget.mediaUrl!);
      } 
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    
    _videoController!.initialize().then((_) {
      if (mounted) { // Check if the widget is still in the widget tree
        setState(() {});
      }
    }).catchError((error) {
      if (mounted) {
        print("Error initializing video player: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load video. Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
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
      // For images, display with click-to-open-fullscreen functionality
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
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  bool _isVideo(String url) {
    // Check if URL contains video identifiers since Firebase URLs lack extensions
    return url.contains('video') || url.contains('mov') || url.contains('mp4') || url.contains('webm');
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
