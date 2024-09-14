import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:citizen/safetyGuides/emergencyPreparedness_guide.dart';
import 'package:citizen/safetyGuides/liveSfaty_guide.dart';
import 'package:citizen/safetyGuides/naturalDisaster_guide.dart';
import 'package:citizen/safetyGuides/socialDisaster_guide.dart';
import 'package:flutter/material.dart';

class EmergencyGuidesPage extends StatefulWidget {
  @override
  _EmergencyGuidesPageState createState() => _EmergencyGuidesPageState();
}

class _EmergencyGuidesPageState extends State<EmergencyGuidesPage> {
  Map<String, String> _selectedGuideDetails = {
    "title": "Select a guide to see details",
    "details": ""
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
          title: Text('Emergency Guides'),
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
                'Safety Guides',
                style: TextStyle(
                  fontSize: isLandscape ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: 'Natural Disaster',
                subtitle:
                    '10 mins ago. Fire reported at Pelmoka Street. Firefighters are on site.',
                imageUrl: 'assets/natural_disaster.jpg',
                details:
                    'Details about natural disasters, including how to stay safe, evacuation procedures, and emergency contacts.',
                guideWidget: NaturalDisasterGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: 'Social Disaster',
                subtitle:
                    '30 mins ago. Heavy rainfall causing floods in Maligaya. Evacuation advised.',
                imageUrl: 'assets/social_disaster.jpg',
                details:
                    'Details about social disasters, including what to do during a flood, safe places, and how to communicate with authorities.',
                guideWidget: SocialDisasterGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: 'Life Safety',
                subtitle:
                    '1 hour ago. Major accident on Maharlika Highway. Traffic is diverted.',
                imageUrl: 'assets/life_safety.jpg',
                details:
                    'Details on life safety, including first aid tips, how to respond to traffic accidents, and emergency numbers.',
                guideWidget: LifeSafetyGuide(),
              ),
              _buildGuideCard(
                context,
                screenSize: screenSize,
                title: 'Emergency Preparedness',
                subtitle:
                    '1 hour ago. Major accident on Maharlika Highway. Traffic is diverted.',
                imageUrl: 'assets/emergency_preparedness.jpg',
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
            SizedBox(height: screenSize.height * 0.01),
            Text(
              _selectedGuideDetails["details"]!,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
              ),
            ),
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
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imageUrl,
              width: screenSize.width * 0.15,
              height: screenSize.width * 0.15,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'lib/images/placeholder_image.png', // Replace with your placeholder image path
                  width: screenSize.width * 0.15,
                  height: screenSize.width * 0.15,
                  fit: BoxFit.cover,
                );
              },
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
            style: TextStyle(fontSize: screenSize.width * 0.035),
          ),
        ),
      ),
    );
  }
}
