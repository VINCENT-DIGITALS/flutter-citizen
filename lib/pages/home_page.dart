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
import 'homepage/announcementcard.dart';
import 'homepage/mapHotLine.dart';
import 'homepage/reportsoscard.dart';

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
  Map<String, dynamic>? _currentWeatherData;
  List<Map<String, dynamic>>? _forecastData;

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

  // Fetch current weather and forecast data from Firestore
  Future<void> _fetchWeatherData() async {
    try {
      var currentWeather = await _dbService.fetchCurrentWeatherData();
      var forecast = await _dbService.fetchForecastData();

      setState(() {
        _currentWeatherData = currentWeather;
        _forecastData = forecast;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching weather data: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleData.locationSuccess.getString(context),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      // await _dbService.updateLocationSharing(
      //   location: GeoPoint(_latitude!,
      //       _longitude!), // Create the GeoPoint using _latitude and _longitude
      // );
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleData.locationError.getString(context)),
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
                    _buildWeatherWidget(formattedDateTime, _currentWeatherData),
                    SizedBox(height: 20),
                    buildReportAndSOSButtons(context, _latitude, _longitude),
                    SizedBox(height: 20),
                    buildEvacuationMapAndHotlineDir(context),
                    SizedBox(height: 20),
                    buildAnnouncements(context),
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
      ),
    );
  }

  Widget _buildWeatherWidget(
      String formattedDateTime, Map<String, dynamic>? weatherData) {
    if (weatherData == null) {
      // Return a placeholder widget until the data is fetched
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    String locationName = weatherData['name'] ?? 'Unknown Location';
    double temperature = weatherData['main']['temp']?.toDouble() ?? 0;
    int humidity = weatherData['main']['humidity'] ?? 0;
    double windSpeed = weatherData['wind']['speed']?.toDouble() ?? 0;
    String weatherDescription =
        weatherData['weather'][0]['description'] ?? 'No Description';
    String weatherIcon = weatherData['weather'][0]['icon'] ?? '01d';

    return GestureDetector(
      onTap: () {
        _showWeatherDialog(
            context); // Show the dialog when the widget is tapped
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: 1.05, // Slightly increase the scale on tap for a subtle effect
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[500]!, Colors.blue[200]!],
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
              Text(locationName,
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
                      Text("${windSpeed.toStringAsFixed(2)} km/h",
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      Text(weatherDescription,
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: AnimatedOpacity(
                          opacity: 0.6, // Make the icon a little transparent
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            Icons.ads_click_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.network(
                        'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
                        width: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/weathericonplaceholder.png',
                          width: 50,
                        ),
                      ),
                      Text('Weather',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show the weather details in a dialog when tapped

  void _showWeatherDialog(BuildContext context) {
    if (_currentWeatherData == null || _forecastData == null) return;

    String locationName = _currentWeatherData!['name'] ?? 'Unknown Location';
    double temperature = _currentWeatherData!['main']['temp']?.toDouble() ?? 0;
    int humidity = _currentWeatherData!['main']['humidity'] ?? 0;
    double windSpeed = _currentWeatherData!['wind']['speed']?.toDouble() ?? 0;
    String weatherDescription =
        _currentWeatherData!['weather'][0]['description'] ?? 'No Description';
    String weatherIcon = _currentWeatherData!['weather'][0]['icon'] ?? '01d';

    PageController _pageController = PageController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 350,
              maxHeight: 450,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                // PageView to slide the weather details horizontally
                PageView.builder(
                  controller: _pageController,
                  itemCount: 1 +
                      _forecastData!.length, // Current weather + forecast pages
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Current weather slide
                      return _buildCurrentWeatherPage(
                        locationName,
                        temperature,
                        humidity,
                        windSpeed,
                        weatherDescription,
                        weatherIcon,
                      );
                    } else {
                      // Forecast slide (index - 1 because the first page is current weather)
                      var forecast = _forecastData![index - 1];
                      return _buildForecastPage(forecast);
                    }
                  },
                ),
                // SmoothPageIndicator at the bottom
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 1 + _forecastData!.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.6),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method to build the current weather page
  Widget _buildCurrentWeatherPage(String location, double temp, int humidity,
      double windSpeed, String description, String icon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current Weather',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            location,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Image.network(
            'https://openweathermap.org/img/wn/$icon@2x.png',
            width: 100,
            errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/weathericonplaceholder.png',
                width: 50),
          ),
          SizedBox(height: 10),
          Text(
            "${temp.toStringAsFixed(1)}°C",
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.water_drop, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "Humidity",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$humidity%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.air, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "Wind Speed",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${windSpeed.toStringAsFixed(2)} km/h",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

// Ensure forecast data exists before accessing properties
  Widget _buildForecastPage(Map<String, dynamic> forecast) {
    // Safely access the forecast data, using null-aware operators and default values
    if (forecast == null ||
        forecast['forecast'] == null ||
        forecast['forecast'][0] == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "Forecast data unavailable",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    double temp = forecast['forecast'][0]['main']['temp']?.toDouble() ?? 0;
    int humidity = forecast['forecast'][0]['main']['humidity'] ?? 0;
    double windSpeed =
        forecast['forecast'][0]['wind']['speed']?.toDouble() ?? 0;
    String description = forecast['forecast'][0]['weather'][0]['description'] ??
        'No Description';
    String icon = forecast['forecast'][0]['weather'][0]['icon'] ?? '01d';
    String dateTime = forecast['forecast'][0]['dt_txt'] ?? 'N/A';
    // Format the date using intl package
    // Convert the dateTime string to a DateTime object
    DateTime date = DateTime.parse(dateTime);
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy')
        .format(date); // "Monday, 15 November 2024"

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Weather Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Image.network(
            'https://openweathermap.org/img/wn/$icon@2x.png',
            width: 100,
            errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/weathericonplaceholder.png',
                width: 50),
          ),
          SizedBox(height: 10),
          Text(
            "${temp.toStringAsFixed(1)}°C",
            style: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.water_drop, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "Humidity",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$humidity%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.air, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "Wind Speed",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${windSpeed.toStringAsFixed(2)} km/h",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
