import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:citizen/safetyGuides/emergencyPreparedness_guide.dart';
import 'package:citizen/safetyGuides/liveSfaty_guide.dart';
import 'package:citizen/safetyGuides/naturalDisaster_guide.dart';
import 'package:citizen/safetyGuides/socialDisaster_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class EmergencyGuidesPage extends StatefulWidget {
  @override
  _EmergencyGuidesPageState createState() => _EmergencyGuidesPageState();
}

class _EmergencyGuidesPageState extends State<EmergencyGuidesPage> {
  Map<String, String> _selectedGuideDetails = {
    "title": "Select a guide to see details",
    // "details": ""
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var isLandscape = screenSize.width > screenSize.height;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(LocaleData.emergencyGuides.getString(context)),
          shadowColor: Colors.black,
          elevation: 2.0,
        ),
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.02,
          ),
          child: ListView(
            children: [
              _buildGuideDetails(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                LocaleData.safetyGuides.getString(context),
                style: TextStyle(
                  fontSize: isLandscape ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: LocaleData.naturalDisaster.getString(context),
                subtitle:
                    'Learn about safety measures and evacuation procedures during natural disasters such as earthquakes, floods, and typhoons.',
                imageUrl: 'assets/images/MoreGuides/NaturalDisaster.png',
                details:
                    'Details about natural disasters, including how to stay safe, evacuation procedures, and emergency contacts.',
                guideWidget: NaturalDisasterGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: LocaleData.socialDisaster.getString(context),
                subtitle:
                    'Guidelines for handling social disasters, including civil unrest and conflicts, and ways to stay safe.',
                imageUrl: 'assets/images/MoreGuides/SocialDisaster.png',
                details:
                    'Details about social disasters, including what to do during a flood, safe places, and how to communicate with authorities.',
                guideWidget: SocialDisasterGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: LocaleData.lifeSafety.getString(context),
                subtitle:
                    'Essential life safety tips for emergencies like accidents, injuries, and basic first aid steps.',
                imageUrl: 'assets/images/MoreGuides/LifeSafety.png',
                details:
                    'Details on life safety, including first aid tips, how to respond to traffic accidents, and emergency numbers.',
                guideWidget: LifeSafetyGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: LocaleData.emergencyPreparedness.getString(context),
                subtitle:
                    'Prepare yourself and your family with essential tips on creating an emergency kit and plans.',
                imageUrl: 'assets/images/MoreGuides/EmergencyPreparedness.png',
                details:
                    'Details on emergency preparedness, including tips on how to prepare an emergency kit, and family communication plans.',
                guideWidget: EmergencyPreparednessGuide(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentPage: 'Guides'),
      ),
    );
  }

  Widget _buildGuideDetails(Size screenSize) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedGuideDetails["title"]!,
              style: TextStyle(
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: screenSize.height * 0.01),
            // // Text(
            // //   _selectedGuideDetails["details"]!,
            // //   style: TextStyle(
            // //     fontSize: screenSize.width * 0.04,
            // //   ),
            // // ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required Size screenSize,
    required String title,
    required String subtitle,
    required String imageUrl,
    required String details,
    required Widget guideWidget,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: guideWidget,
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              // Full-screen view for the image
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: InteractiveViewer(
                        minScale: 0.1,
                        maxScale: 10.0,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: screenSize.width * 0.15,
                height: screenSize.width * 0.15,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/images/placeholder_image.png',
                    width: screenSize.width * 0.15,
                    height: screenSize.width * 0.15,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.045,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: screenSize.width * 0.035), textAlign: TextAlign.justify, // Justify the text here
          ),
        ),
      ),
    );
  }
}
