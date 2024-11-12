import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class AboutCdrrmoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.aboutCDRRMO.getString(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Placeholder image with full-screen zoom on tap
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
                          minScale: 0.1,
                          maxScale: 10.0,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/AboutCDRRMO/CDRRMOLogo.png', // Replace with actual image path
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
                height: isLargeScreen ? 300 : 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage('assets/images/AboutCDRRMO/CDRRMOLogo.png'), // Replace with actual image path
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // About CDRRMO Guide Card
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
                      LocaleData.aboutCDRRMOGuide.getString(context),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      LocaleData.aboutCDRRMOGuideDesc.getString(context),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Mission and Vision Card
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
                      LocaleData.aboutCDRRMOMission.getString(context),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      LocaleData.aboutAppMissionDesc.getString(context),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      LocaleData.aboutCDRRMOVission.getString(context),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      LocaleData.aboutCDRRMOVissionDesc.getString(context),
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
