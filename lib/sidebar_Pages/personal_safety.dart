import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class PersonalSafetyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.personalSafety.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Personal Safety Image/Video Placeholder with Fullscreen Zoom
            GestureDetector(
              onTap: () {
                // Show full-screen zoomable image
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
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/PersonalSafety/PersonalSafetyTips.png', // Replace with actual image path
                                fit: BoxFit.contain,
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
                height: isLargeScreen ? 200 : 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage('assets/images/PersonalSafety/PersonalSafetyTips.png'), // Replace with actual image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Personal Safety Content
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleData.personalSafetyTips.getString(context),
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      LocaleData.personalSafetyTipsDesc.getString(context),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
