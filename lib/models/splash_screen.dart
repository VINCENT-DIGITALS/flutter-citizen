import 'package:citizen/services/auth_page.dart';
import 'package:flutter/material.dart';

import '../core/index.dart';
import '../animations/fade_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> _imageLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Preload the image and wait for it to finish loading
    _imageLoadingFuture = _loadImage();
  }

  Future<void> _loadImage() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final image = AssetImage(isDarkMode ? AppIcon.logoDark : AppIcon.logoWhite);
    await precacheImage(image, context);
    
    // Once the image is loaded, delay before transitioning to AuthPage
    await Future.delayed(const Duration(milliseconds: 1300));
    
    // Navigate to the AuthPage
    Navigator.of(context).pushReplacement(
        CustomRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder(
        future: _imageLoadingFuture,
        builder: (context, snapshot) {
          // Show the splash screen content while the image is loading
          return Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  Image.asset(
                    isDarkMode ? AppIcon.logoDark : AppIcon.logoWhite,
                    height: 130,
                    width: 130,
                  ),
                  const SizedBox(height: 15),
                  
                  // App Name
                  Text(
                    'BAYANi',
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  
                  // Description text
                  Text(
                    'The Official Emergency Response App for\nScience City of Muñoz, Nueva Ecija',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontSize: 16,
                      color: theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
