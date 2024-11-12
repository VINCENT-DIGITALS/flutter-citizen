// privacy_policy_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../privacyPolicyWidget/privacyPolicyPrompt.dart';

class PrivacyPolicyService {
  static Future<void> checkPrivacyPolicyAcceptance(BuildContext context, User user) async {
    final doc = await FirebaseFirestore.instance.collection('citizens').doc(user.uid).get();

    if (!doc.exists || doc.data()?['privacyPolicyAcceptance'] != true) {
      // Show the privacy policy dialog if not accepted
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PrivacyPolicyDialogPrompt(),
      );
    } else {
      // Navigate to HomePage if accepted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
}
