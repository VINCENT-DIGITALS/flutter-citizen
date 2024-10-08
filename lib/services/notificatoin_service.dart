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
    // Android-specific initialization settings
    var androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    // Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request notification permission on Android 13+
    if (Platform.isAndroid) {
      if (await requestNotificationPermission()) {
        // Listen for foreground messages from Firebase Messaging
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            // Display the notification when the app is in the foreground
            showNotification(message.notification!.title ?? "Title",
                message.notification!.body ?? "Body");
          }
        });
      } else {
        // Handle the case when permission is denied
        print("Notification permission denied by user.");
        // Optionally: Show a UI message or a dialog informing the user that notifications are disabled
      }
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

  // Display a local notification on Android
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Customize channel ID
      'your_channel_name', // Customize channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
    // Required: handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    openAppSettings();  // Opens the app's system settings
    print("Opened app settings.");
  }
}
