import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../components/countdown.dart';
import '../../localization/locales.dart';
import '../../services/database_service.dart';
import '../report_page.dart';

final DatabaseService _dbService = DatabaseService();
Widget buildReportAndSOSButtons(
    BuildContext context, double? _latitude, double? _longitude) {
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
                    LocaleData.report.getString(context),
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
