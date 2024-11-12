import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class LifeSafetyGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            LocaleData.lifeSafetyGuide.getString(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.lifeSafetyDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.firstAidBasics.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.firstAidBasicsDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.trafficAccidentResponse.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.trafficAccidentResponseDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.homeSafetyTips.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.homeSafetyTipsDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            LocaleData.lifeSafetyContacts.getString(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            LocaleData.lifeSafetyContactsDesc.getString(context),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
