import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../privacyPolicyWidget/privacyPolicyPrompt.dart';
import 'database_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final StreamSubscription<User?> _authSubscription;
  late final Timer _loadingTimeout;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  DatabaseService _dbservice = DatabaseService();
  bool _hasNavigated = false;
  @override
  void initState() {
    super.initState();

    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        // No internet, check if the user is authenticated
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Retrieve user status and privacy policy acceptance from SharedPreferences
          String? userStatus = prefs.getString('status');
          bool? isPrivacyPolicyAccepted =
              prefs.getBool('privacyPolicyAccepted');

          if (userStatus == 'Deactivated') {
            _showDeactivatedAccountPrompt();
          } else if (isPrivacyPolicyAccepted == true) {
            _navigateToHomePage();
          } else {
            _showPrivacyPolicyDialog(
                currentUser); // Show privacy policy dialog if not accepted
          }
        } else {
          // If not authenticated, navigate to the login page
          _navigateToLoginPage();
        }
      } else {
        // If internet is available, check the authentication status
        final User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _navigateToLoginPage();
        } else {
          await _checkUserStatusAndPrivacyPolicy(user);
        }
      }
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _loadingTimeout.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkUserStatusAndPrivacyPolicy(User user) async {
    try {
      // Start a timer to automatically navigate to LoginPage if loading takes too long
      // _loadingTimeout = Timer(const Duration(seconds: 5), () {
      //   if (mounted && !_hasNavigated) {
      //     _navigateToLoginPage();
      //   }
      // });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check for user data in shared preferences
      bool? isPrivacyPolicyAccepted = prefs.getBool('privacyPolicyAccepted');
      String? userStatus = prefs.getString('status');

      if (isPrivacyPolicyAccepted != null && userStatus != null) {
        if (userStatus == 'Deactivated') {
          _showDeactivatedAccountPrompt();
        } else if (isPrivacyPolicyAccepted) {
          _navigateToHomePage();
        } else {
          _showPrivacyPolicyDialog(user);
        }
      } else {
        // If no data in shared preferences, check Firestore
        await user.reload();
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          final doc = await FirebaseFirestore.instance
              .collection('citizens')
              .doc(currentUser.uid)
              .get();
          final userData = doc.data();

          // Save to shared preferences for future sessions
          if (userData != null) {
            await prefs.setBool('privacyPolicyAccepted',
                userData['privacyPolicyAcceptance'] ?? false);
            await prefs.setString('status', userData['status'] ?? 'Active');
          }

          if (!currentUser.emailVerified) {
            await currentUser.sendEmailVerification();
            _showEmailVerificationPrompt();
          } else if (userData?['status'] == 'Deactivated') {
            _showDeactivatedAccountPrompt();
          } else if (userData?['privacyPolicyAcceptance'] == true) {
            _navigateToHomePage();
          } else {
            _showPrivacyPolicyDialog(currentUser);
          }
        }
      }
    } catch (e) {
      if (e.toString().contains('too-many-requests')) {
        _showRateLimitPrompt();
      } else {
        debugPrint('Error checking user status or privacy policy: $e');
      }
    }
  }

  void _navigateToLoginPage() {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _navigateToHomePage() {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void _showDeactivatedAccountPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Account Deactivated'),
        content: const Text(
          'Your account has been deactivated. Please contact the administrator for assistance.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _signOutAfterVerification();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRateLimitPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verification Request'),
        content: const Text(
          'Verification link already sent. Please verify your email to log in.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToLoginPage();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOutAfterVerification() async {
    await _dbservice.signOut();
    _navigateToLoginPage();
  }

  void _showEmailVerificationPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification Required'),
        content: const Text(
          'A verification link has been sent to your email. Please verify your email to log in.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _signOutAfterVerification();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(User user) {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PrivacyPolicyDialogPrompt(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
