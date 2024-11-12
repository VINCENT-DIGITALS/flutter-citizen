import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../localization/locales.dart';
import '../services/database_service.dart';

class SosCountdownDialog extends StatefulWidget {
  final double latitude;
  final double longitude;

  SosCountdownDialog({required this.latitude, required this.longitude});

  @override
  _SosCountdownDialogState createState() => _SosCountdownDialogState();
}

class _SosCountdownDialogState extends State<SosCountdownDialog> {
  int countdown = 10;
  Timer? timer;
  bool canVibrate = false;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (countdown == 0) {
        timer.cancel();
        handleSOS(); // Trigger SOS functionality here
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void handleSOS() async {
    try {
      GeoPoint location = GeoPoint(widget.latitude, widget.longitude);

      // Get the user ID from the current user in the database service
      String? userId = _dbService.currentUser?.uid;

      if (userId != null) {
        // Add the SOS data to the user's Firestore document
        await _dbService.addSosToUser(userId, location);

        // Show success message
        Navigator.of(context).pop(); // Close the countdown dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                LocaleData.sosTriggered.getString(context),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                LocaleData.yourSos.getString(context),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    LocaleData.close.getString(context),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
        print(
            "SOS triggered with location: ${widget.latitude}, ${widget.longitude}");
      } else {
        print("Error: User is not authenticated.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Unable to retrieve user information.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error sending SOS: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send SOS. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void cancelSOS() {
    timer?.cancel();
    Navigator.of(context).pop(); // Close the countdown dialog
    print("SOS canceled!");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocaleData.sosTriggered.getString(context),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleData.after10.getString(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Circular countdown with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 10.0, end: 0.0),
            duration: Duration(seconds: 10),
            builder: (context, double value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: value / 10,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  // Countdown number animation
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      "${value.ceil()}",
                      key: ValueKey<int>(value.ceil()),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          // Cancel Button
          ElevatedButton(
            onPressed: cancelSOS,
            child: Text(
              LocaleData.cancel.getString(context),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
