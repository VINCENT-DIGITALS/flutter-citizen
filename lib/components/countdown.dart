import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class SosCountdownDialog extends StatefulWidget {
  @override
  _SosCountdownDialogState createState() => _SosCountdownDialogState();
}

class _SosCountdownDialogState extends State<SosCountdownDialog> {
  int countdown = 10;
  Timer? timer;
  bool canVibrate = false;

  @override
  void initState() {
    super.initState();
    checkVibrationSupport();
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Check if the device supports vibration
  Future<void> checkVibrationSupport() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    setState(() {
      canVibrate = hasVibrator ?? false;
    });
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (countdown == 0) {
        timer.cancel();
        handleSOS(); // Trigger SOS functionality here
      } else {
        // Trigger vibration at each second if supported
        if (canVibrate) {
          await Vibration.vibrate(duration: 300); // Vibrate for 300 milliseconds
        }

        setState(() {
          countdown--;
        });
      }
    });
  }

  void handleSOS() {
    // ADD FUNCTION TO INFORM FRIENDS HERE

    Navigator.of(context).pop(); // Close the countdown dialog
    // Show the SOS triggered dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent automatic dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "SOS Triggered!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Your SOS has been sent. Please wait for help or take necessary actions.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Close",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    print("SOS triggered!");
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
        "SOS TRIGGERED!!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "After 10 seconds, your SOS and location will be sent to your Friends.",
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
                        fontSize: 28,
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
            child: Text("Cancel"),
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
