import 'dart:async';
import 'dart:io';
import 'package:citizen/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:citizen/services/location_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:gal/gal.dart';

import '../services/database_service.dart';

class ReportPage extends StatefulWidget {
  final String currentPage;
  const ReportPage({Key? key, this.currentPage = 'report'}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with WidgetsBindingObserver {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _incidentTypeController = TextEditingController();
  final TextEditingController _injuredCountController = TextEditingController();

  String? _selectedSeriousness;
  final LocationService _locationService = LocationService();
  XFile? _selectedMediaFile;
  VideoPlayerController? _videoPlayerController;

  bool _mediaSelected = false;
  bool _videoSelected = false;
  bool _imageSelected = false;
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;

  List<String> incidentTypes = [
    'Car Accident',
    'Fire Incident',
    'Medical Emergency',
    'Natural Disaster',
    'Other',
  ];

  List<String> seriousnessLevels = [
    'Minor',
    'Moderate',
    'Severe',
  ];
  Future<void> _navigateToCamera(bool isVideo) async {
    final mediaFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(isVideoMode: isVideo),
      ),
    );

    if (mediaFile != null) {
      setState(() {
        _selectedMediaFile = mediaFile;
        _videoSelected = isVideo;
        _imageSelected = !isVideo;
        _mediaSelected = true;

        if (isVideo) {
          _videoPlayerController =
              VideoPlayerController.file(File(_selectedMediaFile!.path))
                ..initialize().then((_) {
                  setState(() {});
                  _videoPlayerController!.setLooping(true);
                  _videoPlayerController!.play();
                });
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await _locationService.getCurrentLocation();
      String address = await _locationService.getAddressFromLocation(position);
      setState(() {
        _addressController.text = address;
        _latitude = position.latitude; // Store latitude
        _longitude = position.longitude; // Store longitude
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Success: Access to location been granted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to get current location: enable it in app setting.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_addressController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        !_mediaSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select media.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    LoadingIndicatorDialog().show(context);
    try {
      String? mediaUrl;
      File mediaFile = File(_selectedMediaFile!.path);
      if (_videoSelected) {
        // Convert the video to MP4 format if it's not already
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          _selectedMediaFile!.path,
          quality: VideoQuality.LowQuality,
          deleteOrigin: false, // Keep the original file
        );

        if (mediaInfo != null && mediaInfo.path != null) {
          mediaFile =
              File(mediaInfo.path!); // Update mediaFile with compressed video
          await Gal.putVideo(
              mediaInfo.path!); // Save compressed video to gallery
        } else {
          throw ('Something went wrong, please use Image instead');
        }
        // Upload the video to Firebase Storage
        mediaUrl = await _dbService.uploadMedia(mediaFile, 'videos');
      } else if (_imageSelected) {
        // Upload image as is
        await Gal.putImage(_selectedMediaFile!.path); // Save image to gallery
        mediaUrl = await _dbService.uploadMedia(mediaFile, 'reports');
      }
      // Call the addReport method from DatabaseService with the media URL
      await _dbService.addReport(
        address: _addressController.text,
        landmark: _landmarkController.text,
        description: _descriptionController.text,
        incidentType: _incidentTypeController.text,
        injuredCount: _injuredCountController.text,
        seriousness: _selectedSeriousness ?? '',
        mediaUrl: mediaUrl,
        location: GeoPoint(_latitude!,
            _longitude!), // Create the GeoPoint using _latitude and _longitude
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Report submitted successfully! Media also been saved to gallery.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedMediaFile = null;
          _mediaSelected = false;
          _videoSelected = false;
          _imageSelected = false;
          _videoPlayerController?.dispose();
          _videoPlayerController = null;
          // _incidentTypeController.dispose();
          // _injuredCountController.dispose();
          // _descriptionController.dispose();
          // _landmarkController.dispose();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save media: Something Went Wrong, $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        LoadingIndicatorDialog().dismiss();
      }
    }

    // Additional logic to save the report to the database can be added here
  }

  void _removeSelectedMedia() {
    setState(() {
      _selectedMediaFile = null;
      _mediaSelected = false;
      _videoSelected = false;
      _imageSelected = false;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _videoPlayerController?.dispose();
    _incidentTypeController.dispose();
    _injuredCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Submit Report'),
        shadowColor: Colors.black,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(9.0),
                child: Column(
                  children: [
                    Text('How to use.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      ' Complete all Fields if possible and turning on location is required.\n Video is limited to 5s only. ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: _selectedMediaFile != null
                                      ? _videoSelected
                                          ? _videoPlayerController != null &&
                                                  _videoPlayerController!
                                                      .value.isInitialized
                                              ? AspectRatio(
                                                  aspectRatio:
                                                      _videoPlayerController!
                                                          .value.aspectRatio,
                                                  child: VideoPlayer(
                                                      _videoPlayerController!),
                                                )
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                          : Image.file(
                                              File(_selectedMediaFile!.path),
                                              fit: BoxFit.cover,
                                            )
                                      : const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.videocam,
                                        color: _videoSelected
                                            ? Colors.white
                                            : Colors.black),
                                    label: Text('VIDEO',
                                        style: TextStyle(
                                            color: _videoSelected
                                                ? Colors.white
                                                : Colors.black)),
                                    onPressed: () => _navigateToCamera(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _videoSelected
                                          ? Colors.green
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.image,
                                        color: _imageSelected
                                            ? Colors.white
                                            : Colors.black),
                                    label: Text('IMAGE',
                                        style: TextStyle(
                                            color: _imageSelected
                                                ? Colors.white
                                                : Colors.black)),
                                    onPressed: () => _navigateToCamera(false),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _imageSelected
                                          ? Colors.green
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_mediaSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: _removeSelectedMedia,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: _addressController,
                readOnly: true, // Disable typing
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Click the icon to find location',
                  labelText: 'This is your current address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, // Move label to top
                  suffixIcon: _isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: _getCurrentLocation, // Automatically fill location
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: _landmarkController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText:
                      'Enter an easily recognized Building name or Objects.',
                  labelText: 'Landmark',
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, // Move label to top
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                ),
              ),
            ),

            // Incident Type, Number of Persons Injured, and Seriousness in a Row (Responsive)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Type of Incident',
                              hintText: "Type of Incident",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: _incidentTypeController.text.isNotEmpty
                                ? _incidentTypeController.text
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                _incidentTypeController.text = newValue!;
                              });
                            },
                            items: incidentTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true, // Ensures dropdown is wide enough
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextField(
                            controller: _injuredCountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '# of Injured',
                              hintText: '# of Injured',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always, // Move label to top
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Seriousness',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: _selectedSeriousness,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSeriousness = newValue;
                              });
                            },
                            items: seriousnessLevels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                height: 200,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: 'Report Description',
                    hintText: 'Enter your report description here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.always, // Move label to top
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check,
                      color: Colors.black), // Change icon color to black
                  label: const Text(
                    'Submit Report',
                    style: TextStyle(
                        color: Colors.black), // Change text color to black
                  ),
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.black, // Set the text and icon color to black
                    backgroundColor: const Color.fromARGB(255, 212, 212, 212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final bool isVideoMode;

  const CameraScreen({Key? key, this.isVideoMode = false}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isRecording = false;
  int _recordingDuration = 0; // Timer to show recording time

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.low,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _captureMedia() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (widget.isVideoMode) {
      if (_isRecording) {
        final videoFile = await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _recordingDuration = 0; // Reset timer
        });
        Navigator.pop(context, videoFile);
      } else {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _recordingDuration = 0; // Reset timer to 0 when recording starts
        });

        // Timer to automatically stop recording after 5 seconds
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          setState(() {
            _recordingDuration++; // Update the timer display
          });

          if (_recordingDuration >= 5) {
            timer.cancel();
            if (_isRecording) {
              final videoFile = await _cameraController!.stopVideoRecording();
              setState(() {
                _isRecording = false;
                _recordingDuration = 0; // Reset timer
              });
              Navigator.pop(context, videoFile);
            }
          }
        });
      }
    } else {
      final pictureFile = await _cameraController!.takePicture();
      Navigator.pop(context, pictureFile);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_cameraController!),
                // Back Button
                Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                if (widget.isVideoMode && _isRecording)
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Recording: ${_recordingDuration}s/5s',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      iconSize: 70,
                      icon: Icon(
                        widget.isVideoMode
                            ? (_isRecording ? Icons.stop : Icons.videocam)
                            : Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: _captureMedia,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
