import 'package:citizen/components/custom_drawer.dart';
import 'package:citizen/consts.dart';
import 'package:citizen/services/database_service.dart'; // Import DatabaseService
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? _weatherData;
  final LatLng _initialPosition = const LatLng(15.7156, 120.9246); // Example location
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final data = await _dbService.fetchWeatherData();
    setState(() {
      _weatherData = data;
    });
  }

  Future<void> _refresh() async {
    await _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Today Weather'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey), // Use CustomDrawer
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weatherData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _locationHeader(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _weatherInfoSection(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _bottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    double fontSize = MediaQuery.of(context).size.width * 0.07;
    return Text(
      _weatherData?['name'] ?? "",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _weatherInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _weatherIcon(),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          _currentTemp(),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          _extraInfo(),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          _mapSection(),
        ],
      ),
    );
  }

  Widget _weatherIcon() {
    double iconSize = MediaQuery.of(context).size.height * 0.15;
    return Column(
      children: [
        Container(
          height: iconSize,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weatherData?['weather'][0]['icon']}@4x.png"),
            ),
          ),
        ),
        Text(
          _weatherData?['weather'][0]['description'] ?? "",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: MediaQuery.of(context).size.width * 0.055,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    double tempFontSize = MediaQuery.of(context).size.width * 0.14;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        "${_weatherData?['temperature']}° C",
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: tempFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _extraInfo() {
    double extraInfoFontSize = MediaQuery.of(context).size.width * 0.04;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Feels Like: ${_weatherData?['feelsLike']}° C",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: extraInfoFontSize,
                ),
              ),
              Text(
                "Humidity: ${_weatherData?['humidity']}%",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: extraInfoFontSize,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_weatherData?['windSpeed']} m/s",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: extraInfoFontSize,
                ),
              ),
              Text(
                "Pressure: ${_weatherData?['pressure']} hPa",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: extraInfoFontSize,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _mapSection() {
    double mapHeight = MediaQuery.of(context).size.height * 0.4;
    return Container(
      height: mapHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("current_location"),
              position: _initialPosition,
            ),
          },
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    double buttonFontSize = MediaQuery.of(context).size.width * 0.04;
    double buttonPadding = MediaQuery.of(context).size.width * 0.03;
    double buttonSpacing = MediaQuery.of(context).size.height * 0.01;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: buttonPadding * 2, vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Find Evacuation Center",
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: buttonPadding * 2, vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Find A Friend",
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),
          ],
        ),
        SizedBox(height: buttonSpacing),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: buttonPadding * 2, vertical: buttonPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Send Report",
            style: TextStyle(fontSize: buttonFontSize),
          ),
        ),
      ],
    );
  }
}
