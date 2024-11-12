import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/countdown.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:citizen/pages/announcement_detail_page.dart';
import 'package:citizen/pages/hotlineDirectories_page.dart';
import 'package:citizen/pages/login_page.dart';
import 'package:citizen/pages/post_detail_page.dart';
import 'package:citizen/pages/report_page.dart';
import 'package:citizen/services/database_service.dart';
import 'package:citizen/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import '../api/firebase_api.dart';
import '../localization/locales.dart';
import '../services/notificatoin_service.dart';
import 'evacuationMap_page.dart';

class HomePage extends StatefulWidget {
  final String currentPage;

  const HomePage({Key? key, this.currentPage = 'home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? _prefs;
  final DatabaseService _dbService = DatabaseService();
  Map<String, String> _userData = {};
  bool _isLoading = true;
  final String phoneNumber =
      "09667746951"; // Replace with the phone number you want

  final ScrollController _scrollController = ScrollController();
  final PageController _postsPageController = PageController();
  final PageController _announcementsPageController = PageController();
  Map<String, dynamic>? _weatherData;
  Position? _currentLocation;
  String _currentAddress = "";
  String _errorMessage = "";
  final LocationService _locationService = LocationService();
  double? _latitude;
  double? _longitude;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _fetchLocation();
    _fetchWeatherData();
    // FirebaseApi().initNotifications();
    // Initialize Notification Service for Android
    _initializeNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  // Initialize the notification service
  Future<void> _initializeNotifications() async {
    try {
      await _notificationService
          .initialize(); // This ensures permission request is handled
      bool hasPermission =
          await NotificationService().hasNotificationPermission();
      if (hasPermission) {
        // Request permission when enabling notifications
        bool granted =
            await _notificationService.requestNotificationPermission();
        if (!granted) {
          // Show an alert if permission is denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Notification not enabled, enable it in app setting.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // When disabling notifications, show a confirmation dialog
      }
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  Future<void> _fetchWeatherData() async {
    final data = await _dbService.fetchWeatherData();
    setState(() {
      _weatherData = data;
    });
  }

  Future<void> _fetchLocation() async {
    try {
      _currentLocation = await _locationService.getCurrentLocation();
      _currentAddress =
          await _locationService.getAddressFromLocation(_currentLocation!);
      _errorMessage = "";
      setState(() {
        _latitude = _currentLocation?.latitude; // Store latitude
        _longitude = _currentLocation?.longitude; // Store longitude
      });

      print("Latitude: $_latitude, Longitude: $_longitude");
      bool isLocationServiceEnabled =
          await _locationService.isLocationEnabled();
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(LocaleData.locationSuccess.getString(context),),
          backgroundColor: Colors.green,
        ),
      );
      // await _dbService.updateLocationSharing(
      //   location: GeoPoint(_latitude!,
      //       _longitude!), // Create the GeoPoint using _latitude and _longitude
      // );
    } catch (e) {
       _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
              LocaleData.locationError.getString(context)),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {});
    print("$_currentLocation");
    print("$_currentAddress");
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _fetchAndDisplayUserData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchAndDisplayUserData() async {
    try {
      _userData = {
        'uid': _prefs?.getString('uid') ?? '',
        'email': _prefs?.getString('email') ?? '',
        'displayName': _prefs?.getString('displayName') ?? '',
        'photoURL': _prefs?.getString('photoURL') ?? '',
        'phoneNum': _prefs?.getString('phoneNum') ?? '',
        'createdAt': _prefs?.getString('createdAt') ?? '',
        'address': _prefs?.getString('address') ?? '',
        'status': _prefs?.getString('status') ?? '',
      };
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _dialNumber(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat('MMMM d, h:mm a', 'en_PH').format(
        DateTime.now()
            .toUtc()
            .add(Duration(hours: 8))); // UTC+8 for Philippines
    String locationName = _weatherData?['name'] ?? 'Science City of Muñoz, PH';

    int humidity = _weatherData?['humidity'] ?? 0;

    double temperature = (_weatherData?['temperature'] ?? 0).toDouble();
    double feelsLike = (_weatherData?['feelsLike'] ?? 0).toDouble();
    double windSpeed = (_weatherData?['windSpeed'] ?? 0).toDouble();
    String weatherDescription = _weatherData != null &&
            _weatherData!['weather'] != null &&
            (_weatherData!['weather'] as List).isNotEmpty
        ? _weatherData!['weather'][0]['description'] ??
            'Clear sky, Light breeze'
        : 'Clear sky, Light breeze';
    String weatherIcon = _weatherData != null &&
            _weatherData!['weather'] != null &&
            (_weatherData!['weather'] as List).isNotEmpty
        ? _weatherData!['weather'][0]['icon'] ?? '01d'
        : '01d';
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.phone, color: Colors.orange, size: 40),
              onPressed: () => _dialNumber(phoneNumber),
            ),
          ],
        ),
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(
                controller: _scrollController,
                thickness: 5,
                thumbVisibility: true,
                radius: Radius.circular(5),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildWeatherWidget(
                      formattedDateTime,
                      locationName,
                      temperature,
                      humidity,
                      windSpeed,
                      feelsLike,
                      weatherDescription,
                      weatherIcon,
                    ),
                    SizedBox(height: 20),
                    _buildReportAndSOSButtons(context),
                    SizedBox(height: 20),
                    _buildEvacuationMapAndHotlineDir(context),
                    SizedBox(height: 20),
                    _buildAnnouncements(),
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
      ),
    );
  }

  Widget _buildWeatherWidget(
      String formattedDateTime,
      String locationName,
      double temperature,
      int humidity,
      double windSpeed,
      double feelsLike,
      String weatherDescription,
      String weatherIcon) {
    String dayOfWeek = DateFormat('EEEE', 'en_PH').format(DateTime.now()
        .toUtc()
        .add(Duration(hours: 8))); // UTC+8 for PhilippinesF
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[200]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedDateTime,
              style: TextStyle(fontSize: 12, color: Colors.white)),
          Text('$locationName',
              style: TextStyle(fontSize: 12, color: Colors.white)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${temperature.toStringAsFixed(1)}°C",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  Text("$humidity%",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  Text("${windSpeed.toStringAsFixed(2)}km/h",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  Text("${feelsLike.toStringAsFixed(1)}°C",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  Text(weatherDescription,
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(LocaleData.weather.getString(context),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(dayOfWeek,
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ],
          ),
          // SizedBox(height: 16.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Text('Morning\n29°C', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
          //     Text('Afternoon\n33°C', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
          //     Text('Evening\n31°C', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
          //     Text('Night\n27°C', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildReportAndSOSButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double fontSize =
        screenWidth < 400 ? 14 : 16; // Adjust font size for smaller screens
    double iconSize =
        screenWidth < 400 ? 30 : 40; // Adjust icon size for smaller screens

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_dbService.isAuthenticated()) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReportPage();
                  },
                );
              } else {
                _dbService.redirectToLogin(context);
              }
            },
            child: Material(
              elevation: 8, // Add shadow elevation
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16), // Add padding for the shadow
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the button
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Increase to make the shadow softer
                      offset: Offset(0, 4), // X, Y offset for the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.report,
                        color: Colors.red[600], size: iconSize), // Use an icon
                    SizedBox(height: 8),
                    Text(
                      LocaleData.report.getString(context) ,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (_dbService.isAuthenticated()) {
                if (_latitude != null && _longitude != null) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SosCountdownDialog(
                        latitude: _latitude!,
                        longitude: _longitude!,
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Failed to retrieve your location. Try again later.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                _dbService.redirectToLogin(context);
              }
            },
            child: Material(
              elevation: 8, // Add shadow elevation
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16), // Add padding for the shadow
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the button
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Increase to make the shadow softer
                      offset: Offset(0, 4), // X, Y offset for the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.warning,
                        color: Colors.yellow, size: iconSize), // Use an icon
                    SizedBox(height: 8),
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.teal[600],
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvacuationMapAndHotlineDir(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double fontSize =
        screenWidth < 400 ? 14 : 16; // Adjust font size for smaller screens
    double iconSize =
        screenWidth < 400 ? 30 : 40; // Adjust icon size for smaller screens

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EvacuationMapPage();
                },
              );
            },
            child: Material(
              elevation: 8, // Add shadow elevation
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16), // Add padding for the shadow
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the button
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Increase to make the shadow softer
                      offset: Offset(0, 4), // X, Y offset for the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.map,
                        color: Colors.green, size: iconSize), // Use an icon
                    SizedBox(height: 8),
                    Text(
                      LocaleData.evacuationCenter.getString(context),
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return HotlineDirectoriesPage();
                },
              );
            },
            child: Material(
              elevation: 8, // Add shadow elevation
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16), // Add padding for the shadow
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the button
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Increase to make the shadow softer
                      offset: Offset(0, 4), // X, Y offset for the shadow
                    ),
                  ],
                ),
                
                child: Column(
                  children: [
                    Icon(Icons.phone,
                        color: Colors.blue, size: iconSize), // Use an icon
                    SizedBox(height: 8),
                    FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
    LocaleData.hotlineDirec.getString(context),
    style: TextStyle(
      color: Colors.grey[800],
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
    maxLines: 2,
  ),
)


                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncements() {
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
                    return _buildAnnouncementCard(announcements[index]);
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

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
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
}
