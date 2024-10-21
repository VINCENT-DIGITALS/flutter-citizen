import 'dart:convert';

import 'package:citizen/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //Create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  //Function to initialize notification
  Future<void> initNotifications(String userId) async {
    //request permission from user {will prompt user}
    await _firebaseMessaging.requestPermission();

    // fetch the FCM Token for the device
    final fcmToken = await _firebaseMessaging.getToken();
    // Get the current token and save it to Firestore

    if (fcmToken != null) {
      await saveTokenToDatabase(fcmToken, userId);
    }
    // Listen for token refresh events and update Firestore
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      saveTokenToDatabase(newToken, userId);
    });

    void handleMessage(RemoteMessage? message) {
      if (message == null) return;

      //Navigate to new screen when message is recieved and user tops notification
      navigatorKey.currentState
          ?.pushNamed('/notitication_screen', arguments: message);
    }

    Future initPushNotification() async {
      //Handle notific if the app was terminated and now opened
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

      //Attached event listeners for when a notification opens the app
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    }
  }

  // Function to save the token to Firestore
  Future<void> saveTokenToDatabase(String token, String userId) async {
    // Get the reference to the user's document in Firestore
    final userRef =
        FirebaseFirestore.instance.collection('citizens').doc(userId);

    // Update the token field (use a specific field like 'fcmToken' for consistency)
    await userRef.set({
      'fcmToken': token,
      'lastUpdated': FieldValue
                .serverTimestamp(), // Update the last updated timestamp
    }, SetOptions(merge: true));
    print("FCM Token saved to Firestore: $token");
  }

  // Function to handle recieved messages

  //Function to initialize foreground and background settinfs
}
