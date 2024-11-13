import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../localization/locales.dart';
import '../../services/database_service.dart';
import '../evacuationMap_page.dart';
import '../hotlineDirectories_page.dart';

final DatabaseService _dbService = DatabaseService();
Widget buildEvacuationMapAndHotlineDir(BuildContext context) {
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
