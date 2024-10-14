import 'package:flutter/material.dart';
import '../services/auth_page.dart';
import '../core/index.dart';
import '../animations/fade_transition.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1300)).then((value) =>
        Navigator.of(context).pushReplacement(
            CustomRoute(builder: ((context) => const AuthPage()))));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Image.asset(isDarkMode ? AppIcon.logoDark : AppIcon.logoWhite,
                  height: 130, width: 130),
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
      ),
    );
  }
}
