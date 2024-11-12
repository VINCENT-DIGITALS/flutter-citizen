import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class NaturalDisasterGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            LocaleData.naturalDisasterGuide.getString(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.naturalDisasterGuideDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.naturalDisasterprep.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.naturalDisasterprepdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.naturalDisasterDuring.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.naturalDisasterDuringdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.naturalDisasterAfter.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.naturalDisasterAfterdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.naturalDisasterContacts.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.naturalDisasterContactsdesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          // Add more detailed sections if needed
        ],
      ),
    );
  }
}
