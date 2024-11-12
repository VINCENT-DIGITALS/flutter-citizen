import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class SocialDisasterGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            LocaleData.socialDisasterGuide.getString(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.socialDisasterGuideDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.socialDisasterprep.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.socialDisasterprepdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.socialDisasterDuring.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.socialDisasterDuringdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.socialDisasterAfter.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.socialDisasterAfterdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.socialDisasterContacts.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.socialDisasterContactsdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          // Add more detailed sections if needed
        ],
      ),
    );
  }
}
