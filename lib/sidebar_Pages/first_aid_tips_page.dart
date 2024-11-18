import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class FirstAidTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.firstAidTips.getString(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section for CPR Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.cardiopulmonaryR.getString(context),
              'assets/images/FirstAidTips/CPR(CardiopulmonaryResuscitation).png',
              LocaleData.cPRDesc.getString(context),
            ),
            SizedBox(height: 20),

            // Section for Bleeding Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.bleeding.getString(context),
              'assets/images/FirstAidTips/Bleeding.png',
              LocaleData.bleedingDesc.getString(context),
            ),
            SizedBox(height: 20),

            // Section for Burns Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.burns.getString(context),
              'assets/images/FirstAidTips/burns.png',
              LocaleData.burnDesc.getString(context),
            ),
            SizedBox(height: 20),

            // Section for Choking Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.choking.getString(context),
              'assets/images/FirstAidTips/Choking.png',
              LocaleData.chokingDesc.getString(context),
            ),
            SizedBox(height: 20),

            // Section for Poisoning Tips
            _buildSection(
              context,
              isLargeScreen,
              LocaleData.poisoning.getString(context),
              'assets/images/FirstAidTips/Poisoning.png',
              LocaleData.poisoningDesc.getString(context),
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
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              // barrierColor: Colors.black87, // Dark background for full-screen effect
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      minScale: 0.1,
                      maxScale: 10.0,
                      child: Container(
                        // color: Colors.black, // Optional: background color for the dialog
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
            height: isLargeScreen ? 300 : 180,
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
