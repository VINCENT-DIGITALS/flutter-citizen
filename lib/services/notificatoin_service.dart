import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this for handling permissions
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the service for Android
  Future<void> initialize() async {
    try {
      // Android-specific initialization settings
      var androidInitSettings =
          const AndroidInitializationSettings('@mipmap/launcher_icon');
      var initSettings = InitializationSettings(
        android: androidInitSettings,
      );
      // Initialize local notifications
      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
      // Create both notification channels
      await _createNotificationChannel(); // Primary channel
      await _createSecondaryNotificationChannel(); // Secondary channel

      // Request notification permission on Android 13+
      if (Platform.isAndroid) {
        if (await requestNotificationPermission()) {
          // Listen for foreground messages from Firebase Messaging
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            if (message.data['type'] == 'main') {
              showNotification(
                message.notification?.title ?? "Main Title",
                message.notification?.body ?? "Main Body",
              );
            } else if (message.data['type'] == 'secondary') {
              showSecondaryNotification(
                message.notification?.title ?? "Secondary Title",
                message.notification?.body ?? "Secondary Body",
              );
            } else {
              showNotification(
                message.notification?.title ?? "General Title",
                message.notification?.body ?? "General Body",
              );
            }
          });
        } else {
          // Handle the case when permission is denied
          print("Notification permission denied by user.");
          // Optionally: Show a UI message or a dialog informing the user that notifications are disabled
        }

        // Create notification channel for Android if not already created
        await _createNotificationChannel();
      }
    } catch (e) {
      print("Error during NotificationService initialization: $e");
    }
  }

  // Function to request notification permission (Android 13+)
  Future<bool> requestNotificationPermission() async {
    // Only request permission on Android 13+ (API level 33+)
    if (await Permission.notification.isGranted) {
      return true;
    }

    // Request notification permission
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      return true; // Permission granted
    } else if (status.isDenied) {
      print("Notification permission denied.");
      // Optionally, show a dialog informing the user why notifications are important
    } else if (status.isPermanentlyDenied) {
      print(
          "Notification permission permanently denied. You may need to guide the user to app settings.");
      // You can prompt the user to manually enable notifications from app settings
      // openAppSettings();  // Opens the app settings
    }

    return false; // Permission was not granted
  }

  // Check notification permissions
  Future<bool> hasNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }

  // Display a local notification on Android with a custom sound
  Future<void> showNotification(String title, String body) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'emergency_channel', // Customize channel ID
      'Emergency Notifications', // Customize channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound(
          'emergencynotifsound'), // Reference to custom sound (no extension needed)
      playSound: true, // Make sure sound plays
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Trigger the notification and repeat it (e.g., every 5 seconds)
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );

    // Repeat the notification every 5 seconds (simulate the sound repeating)
    Future.delayed(Duration(seconds: 5), () {
      flutterLocalNotificationsPlugin.show(
        1, // Notification ID (different ID to allow for multiple notifications)
        title,
        body,
        platformChannelSpecifics,
        payload: 'Notification Payload',
      );
    });
  }

// Function to display secondary notification with different sound
  Future<void> showSecondaryNotification(String title, String body) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'chat_channel', // Secondary channel ID
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
          'chatsound'), // Different custom sound
      playSound: true,
    );
    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1, // Different Notification ID
      title,
      body,
      platformDetails,
      payload: 'Secondary Notification Payload',
    );
  }

// Define a new notification channel for the second type of notifications
  Future<void> _createSecondaryNotificationChannel() async {
    var secondaryNotificationChannel = AndroidNotificationChannel(
      'chat_channel', // New channel ID
      'Chat Notifications', // New channel name
      description: 'Channel for chat notifications with different sound',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound(
          'chatsound'), // Reference to another custom sound (no extension needed)
      playSound: true,
    );

    // Create the secondary channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(secondaryNotificationChannel);
  }

  // Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      'emergency_channel', // Channel ID
      'Emergency Notifications', // Channel Name
      description: 'Channel for emergency notifications',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('emergencynotifsound'),
      playSound: true,
    );

    // Create the channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  // Required: handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  // Called when the user taps on a notification
  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print("Notification tapped with payload: ${notificationResponse.payload}");
  }

  // Method to open app settings where users can enable or disable notifications
  Future<void> openAppSettings() async {
    openAppSettings(); // Opens the app's system settings
    print("Opened app settings.");
  }
}
