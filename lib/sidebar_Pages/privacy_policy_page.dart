import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.privacyPolicy.getString(context),
          textAlign: TextAlign.center,
        ),
        toolbarHeight: isLargeScreen ? 80 : 60,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 32.0 : 16.0,
                  vertical: 24.0,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Text(
                        'BAYANi - CDRRMO Science City of Muñoz\nEmergency Response Application',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 25 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        LocaleData.privacyPolicy.getString(context),
                        style: TextStyle(
                          fontSize: isLargeScreen ? 30 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        LocaleData.privacyPolicyDate.getString(context),
                        style: TextStyle(
                          fontSize: isLargeScreen ? 18 : 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyContactUs.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyContactUsDesc.getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicydatacontroller.getString(context),
                      LocaleData.privacyPolicyContactdatacontrollerDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyContactEmail.getString(context),
                      '',
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicydatacollected.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicydatacollectedDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicydatacollectedContactInfo
                          .getString(context),
                      LocaleData.privacyPolicydatacollectedContactInfoDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicydatacollectedProfileInfo
                          .getString(context),
                      LocaleData.privacyPolicydatacollectedProfileInfoDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicydatacollectedIncidentDetails
                          .getString(context),
                      LocaleData.privacyPolicydatacollectedIncidentDetailsDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicydatacollectedLocationData
                          .getString(context),
                      LocaleData.privacyPolicydatacollectedLocationDataDesc
                          .getString(context),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyWhycollectdata.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyWhycollectdataDesc
                          .getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyWhycollectdataPurposes
                          .getString(context),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyDataVisibility.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyDataVisibilityDesc
                          .getString(context),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyyourRights.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyyourRightsDesc.getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyyourRightsAccessToData
                          .getString(context),
                      LocaleData.privacyPolicyyourRightsAccessToDataDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyyourRightsDataCorrection
                          .getString(context),
                      LocaleData.privacyPolicyyourRightsDataCorrectionDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyyourRightsDataDeletion
                          .getString(context),
                      LocaleData.privacyPolicyyourRightsDataDeletionDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyyourRightsUsageRestrict
                          .getString(context),
                      LocaleData.privacyPolicyyourRightsUsageRestrictDesc
                          .getString(context),
                    ),
                    buildDataRow(
                      context,
                      LocaleData.privacyPolicyyourRightsLocationSettings
                          .getString(context),
                      LocaleData.privacyPolicyyourRightsLocationSettingsDesc
                          .getString(context),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyDisclaimer.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyDisclaimerDesc.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyDisclaimerDescLast
                          .getString(context),
                    ),
                    Divider(height: 30, color: Colors.black26),
                    buildSectionHeader(
                      context,
                      LocaleData.privacyPolicyContactUs.getString(context),
                    ),
                    buildSectionBody(
                      context,
                      LocaleData.privacyPolicyContactUsDesc.getString(context),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        LocaleData.allrightreserved.getString(context),
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.orange[900],
      ),
    );
  }

  Widget buildSectionBody(BuildContext context, String bodyText) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        bodyText,
        style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
      ),
    );
  }

  Widget buildDataRow(BuildContext context, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              desc,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
