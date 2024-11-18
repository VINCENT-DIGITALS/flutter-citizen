import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class EmergencyPreparednessGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            LocaleData.emergencyPreparednessGuide.getString(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.emergencyPreparednessGuideDesc.getString(context),
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify, // Justify the text here
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.emergencyPreparednessKit.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.emergencyPreparednessKitDesc.getString(context),
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify, // Justify the text here
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.emergencyPreparednessFamilyPlan.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.emergencyPreparednessFamilyPlanDesc.getString(context),
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify, // Justify the text here
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.emergencyPreparednessprepHome.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.emergencyPreparednessprepHomeDesc.getString(context),
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify, // Justify the text here
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.emergencyPreparednessContacts.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.emergencyPreparednessContactsDesc.getString(context),
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify, // Justify the text here
          ),
        ],
      ),
    );
  }
}
