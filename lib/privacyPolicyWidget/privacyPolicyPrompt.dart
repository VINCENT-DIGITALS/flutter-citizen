import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';
import '../services/auth_page.dart';
import '../services/shared_pref.dart';

class PrivacyPolicyDialogPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: isLargeScreen ? 600 : screenSize.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                LocaleData.privacyPolicydatacollectedDesc.getString(context),
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
                LocaleData.privacyPolicyWhycollectdataDesc.getString(context),
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
                LocaleData.privacyPolicyDataVisibilityDesc.getString(context),
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
                LocaleData.privacyPolicyDisclaimerDescLast.getString(context),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _handleReject(context),
                    child: Text(
                      'Reject',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleAccept(context),
                    child: Text('Accept'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleReject(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  Future<void> _handleAccept(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('citizens')
            .doc(user.uid)
            .set({'privacyPolicyAcceptance': true}, SetOptions(merge: true));

        SharedPreferencesService prefs =
            await SharedPreferencesService.getInstance();
        prefs.saveUserData({
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': displayName,
          'photoURL': user.photoURL ?? '',
          'phoneNum': user.phoneNumber ?? '',
          'createdAt': DateTime.now().toIso8601String(),
          'address': '',
          'type': 'citizen',
          'status': 'Activated',
          'privacyPolicyAccepted': true,
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      } catch (e) {
        // Handle the error if needed
      }
    }
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
        style: TextStyle(fontSize: 16),
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
