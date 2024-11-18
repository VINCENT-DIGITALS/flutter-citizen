import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class MentalHealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.mentalHealth.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Full-screen zoomable image for mental health image/video placeholder
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Center(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/MentalHealth/MentalHealthAwareness.png', // Replace with actual image path
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: isLargeScreen ? 300 : 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/MentalHealth/MentalHealthAwareness.png'), // Replace with actual image path
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Mental Health Overview
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
                      LocaleData.mentalHealthAwareness.getString(context),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      LocaleData.mentalHealthAwarenessDesc.getString(context),
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Full-screen zoomable placeholder for Mental Health Resources image/video
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Center(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/MentalHealth/Self-CareTipsforMentalHealth.png', // Replace with actual image path
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: isLargeScreen ? 250 : 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/MentalHealth/Self-CareTipsforMentalHealth.png'), // Replace with actual image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Card for Self-Care Tips
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
                      LocaleData.selfCareTips.getString(context),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      LocaleData.selfCareTipsDesc.getString(context), textAlign: TextAlign.justify, // Justify the text here
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
