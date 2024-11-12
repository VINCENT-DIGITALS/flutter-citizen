import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

    // Listen to connectivity changes for active connectivity types
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      if (!_hasNavigated) {
        if (result.contains(ConnectivityResult.none)) {
          // No internet, check if the user is authenticated
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            _navigateToHomePage();
          } else {
            _navigateToLoginPage();
          }
        } else {
          // With internet, check auth status
          _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
            if (user == null) {
              _navigateToLoginPage();
            } else {
              await _checkUserStatusAndPrivacyPolicy(user);
            }
          });
        }
      }
    });

    // Start a timer to automatically navigate to LoginPage if loading takes too long
    _loadingTimeout = Timer(const Duration(seconds: 5), () {
      if (mounted && !_hasNavigated) {
        _navigateToLoginPage();
      }
    });
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
      await user.reload();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final doc = await FirebaseFirestore.instance
            .collection('citizens')
            .doc(currentUser.uid)
            .get();
        final userData = doc.data();

        if (!currentUser.emailVerified) {
          await currentUser.sendEmailVerification();
          if (mounted) {
            _showEmailVerificationPrompt();
          }
        } else if (userData?['status'] == 'Deactivated') {
          if (mounted) {
            _showDeactivatedAccountPrompt();
          }
        } else if (userData?['privacyPolicyAcceptance'] == true) {
          _navigateToHomePage();
        } else {
          if (mounted) _showPrivacyPolicyDialog(currentUser);
        }
      }
    } catch (e) {
      if (e.toString().contains('too-many-requests')) {
        if (mounted) {
          _showRateLimitPrompt();
        }
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
