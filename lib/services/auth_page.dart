import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the snapshot has data
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the authentication state
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // If the user is authenticated, navigate to HomePage
            return const HomePage();
          } else if (snapshot.hasError) {
            // Handle any errors here
            return const Center(child: Text('An error occurred. Please try again.'));
          } else {
            // If the user is not authenticated, show the LoginPage
            return const LoginPage();
          }
        },
      ),
    );
  }
}
