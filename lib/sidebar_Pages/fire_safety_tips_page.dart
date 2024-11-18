import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class FireSafetyTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.fireSafetyTips.getString(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section for Smoke Alarm Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.installSmokeAlarms.getString(context),
              'assets/images/FireSafetyTips/InstallSmoke Alarms.png', // Placeholder image path
              LocaleData.installSmokeAlarmsDesc.getString(context),
            ),
            SizedBox(height: 20),

            // Section for Fire Escape Plan
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.createAnEscapePlan.getString(context),
              'assets/images/FireSafetyTips/CreateanEscapePlan.png', // Placeholder image path
              LocaleData.createAnEscapePlanDesc.getString(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    bool isLargeScreen,
    String title,
    String imagePath,
    String details,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Show full-screen image with zoom
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                                imagePath,
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
            child: Container(
              height: isLargeScreen ? 250 : 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    details,
                    style: TextStyle(fontSize: 16),
                     textAlign: TextAlign.justify, // Justify the text here
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
