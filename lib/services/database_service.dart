import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:citizen/services/firebase_exceptions.dart';
import 'package:citizen/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Check if an email already exists
  Future<bool> doesEmailExist(String email) async {
    // Query all relevant collections where an email might exist
    final citizenQuery =
        _db.collection('citizens').where('email', isEqualTo: email).get();

    // Await all the queries
    final results = await Future.wait([citizenQuery]);

    // Check if any of the queries returned documents
    final emailExists = results.any((query) => query.docs.isNotEmpty);
    return emailExists;
  }

  // Check if an email belongs to a citizen
  Future<bool> isAuthorizedEmail(String email) async {
    final citizenQuery =
        _db.collection('citizens').where('email', isEqualTo: email).get();
    final results = await Future.wait([citizenQuery]);
    final isCitizen = results[0].docs.isNotEmpty;
    return isCitizen;
  }

  // Getter for the current user
  User? get currentUser {
    return _auth.currentUser;
  }

  // Method to fetch current user data once
  Future<Map<String, dynamic>> fetchCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('citizens')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No data available for the current user');
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return userData;
    } catch (e) {
      // Handle errors
      throw Exception('Error fetching user data: $e');
    }
  }

  // Method to update specific fields of the current user document
  Future<void> updateUserData({
    required Map<String, dynamic> updatedFields,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final userRef = _db.collection('citizens').doc(user.uid);
      await userRef.update(updatedFields);
    } catch (e) {
      // Handle errors
      throw Exception('Error updating user data: $e');
    }
  }

  Future<String?> uploadMedia(File mediaFile, String mediaType) async {
    try {
      // Create a folder with the current date and time
      String dateTimeNow = DateTime.now()
          .toIso8601String(); // Example: '2024-09-14T12:34:56.789'

      // Define the path as "reports" folder with a subfolder named by current date and time
      String fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Unique filename based on timestamp
      Reference ref = _storage.ref().child(
          'reports/$dateTimeNow/$fileName'); // Folder: "reports/{current_date_time}"

      // Upload the media file
      UploadTask uploadTask = ref.putFile(mediaFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Return the download URL of the uploaded file
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  // Method to add a report to Firestore
  Future<void> addReport({
    required String address,
    required String landmark,
    required String description,
    required String incidentType,
    required String injuredCount,
    required String seriousness,
    String? mediaUrl,
  }) async {
    try {
      
      final reportData = {
        'reporterId': currentUser?.uid ?? 'unknown',
        'address': address,
        'landmark': landmark,
        'description': description,
        'incidentType': incidentType,
        'injuredCount': injuredCount,
        'seriousness': seriousness,
        'mediaUrl': mediaUrl ?? '', // Store media URL in Firestore
        'acceptedByOperator': false, // Default to false until operator accepts
        'responderTeam': '', // Add team when assigned
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _db.collection('reports').add(reportData);
    } catch (e) {
      throw Exception('Failed to add report: $e');
    }
  }

  // Method to update a document with a specified ID
  Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    _checkAuthentication();
    return await _db.collection(collectionPath).doc(documentId).update(data);
  }

  // Method to delete a document with a specified ID
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    _checkAuthentication();
    return await _db.collection(collectionPath).doc(documentId).delete();
  }

  // Private method to check authentication
  void _checkAuthentication() {
    if (!isAuthenticated()) {
      throw Exception("User not authenticated");
    }
  }

  // Method to fetch weather data
  Future<Map<String, dynamic>?> fetchWeatherData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection('weather').doc('weatherData').get();
      if (doc.exists) {
        return doc.data();
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }

  Future<void> addFriends(String userId, List<String> friendIds) async {
    final friendsDoc = _db.collection("friends").doc(userId);
    await friendsDoc.set({
      'friendIds': FieldValue.arrayUnion(friendIds),
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFriends(String userId) async {
    final friendsDoc = _db.collection("friends").doc(userId);
    final docSnapshot = await friendsDoc.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data['friendIds'] != null) {
        return List<String>.from(data['friendIds']);
      }
    }
    return [];
  }

  void flutterToastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void flutterToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Future<String?> verifyPhone() async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: '+44 7123 123 456',
  //     verificationFailed: (FirebaseAuthException e) {
  //       if (e.code == 'invalid-phone-number') {
  //         print('The provided phone number is not valid.');
  //       }

  //       // Handle other errors
  //     },
  //   );
  // }

  bool isValidPassword(String password) {
    // Check if password is at least 6 characters long
    return password.length >= 6;
  }

  bool isValidEmail(String email) {
    // Regular expression for validating an email
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(email);
  }

  Future<UserCredential> registerWithEmailAndPassword(String email,
      String password, String displayName, String phoneNumber) async {
    try {
      // Try to create the user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure the user document exists in Firestore
      await _createUserDocumentIfNotExists(
          userCredential.user, displayName, phoneNumber, email);

      // Store user details in SharedPreferences
      if (userCredential.user != null) {
        User user = userCredential.user!;
        SharedPreferencesService prefs =
            await SharedPreferencesService.getInstance();
        prefs.saveUserData({
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': displayName,
          'photoURL': user.photoURL ?? '',
          'phoneNum': phoneNumber,
          'createdAt': DateTime.now().toIso8601String(),
          'address': '',
          'type': 'citizen',
          'status': 'Activated',
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Caught FirebaseAuthException: ${e.code}');
      print('Error message: ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          flutterToast('The email address is already in use');
          break;
        case 'weak-password':
          flutterToast('The password is too weak, at least six characters');
          break;
        case 'invalid-email':
          flutterToast('The email address is not valid.');
          break;
        default:
          flutterToast('Something went wrong, please try again1');
          break;
      }
      throw (e.code);
    } catch (e) {
      flutterToast('Something went wrong, please try again');
      throw Exception('Something went wrong: $e');
    }
  }

// Create user document in Firestore if it doesn't already exist
  Future<void> _createUserDocumentIfNotExists(User? user,
      [String? displayName, String? phoneNumber, String? email]) async {
    if (user != null) {
      final userDoc = _db.collection("citizens").doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        final userInfoMap = {
          // 'uid': user.uid,   redundant
          'email': user.email,
          'displayName': displayName ?? user.displayName,
          'photoURL': user.photoURL,
          'phoneNum': phoneNumber ?? user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'address': '',
          'type': 'citizen',
          'status': 'Activated',
        };

        await userDoc.set(userInfoMap);

        await sendEmailVerification(email);
      } //else
    }
  }

  //Email verification
  Future<void> sendEmailVerification(String? email) async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      flutterToast('Email verification has been sent to your email.');
    } catch (e) {
      print('Something went wrong: $e');
      flutterToast('Something went wrong, please try again');
    }
  }

  Future<String?> createGoogleUser() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return 'User canceled the sign-in process';
      }

      // Obtain auth details from user
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) {
        return 'Google sign-in failed';
      }

      // Create Firestore document
      await _createUserDocumentIfNotExists(
          user, gUser.displayName, '', gUser.email);

      return 'Account successfully created.';
    } catch (e) {
      print("Something went wrong: $e");
      return 'An unknown error occurred: $e';
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return 'User canceled the sign-in process';
      }

      // Obtain auth details from user
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Obtain the user's email from Google sign-in
      final email = gUser.email;

      // Fetch user document from Firestore
      final userDoc =
          _db.collection("citizens").where('email', isEqualTo: email).limit(1);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.docs.isEmpty) {
        return 'Account does not exist. Please register first.';
      }

      final userData = docSnapshot.docs.first.data();
      if (userData['status'] == 'Deactivated') {
        return 'User account is deactivated, contact the operator to activate';
      }

      // Sign in to Firebase with the credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store user details in SharedPreferences
      SharedPreferencesService prefs =
          await SharedPreferencesService.getInstance();
      prefs.saveUserData({
        'uid': userData['uid'] ?? '',
        'email': userData['email'] ?? '',
        'displayName': userData['displayName'] ?? '',
        'photoURL': userData['photoURL'] ?? '',
        'phoneNum': userData['phoneNum'] ?? '',
        'createdAt':
            (userData['createdAt'] as Timestamp).toDate().toIso8601String(),
        'address': userData['address'] ?? '',
        'type': userData['type'] ?? '',
        'status': userData['status'] ?? '',
      });

      return null;
    } catch (e) {
      print("Something went wrong: $e");
      return 'Something went wrong, please try again';
    }
  }

// Sign in with email and password (Only for authorized users)
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      // Fetch user document from Firestore
      final userDoc =
          _db.collection("citizens").where('email', isEqualTo: email).limit(1);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.docs.isEmpty) {
        // flutterToastError('User document does not exist');
        return 'Account does not exist';
      }

      final userData = docSnapshot.docs.first.data();
      final documentId = docSnapshot.docs.first.id;
      if (userData['status'] == 'Deactivated') {
        //flutterToast('User account is deactivated, contact the operator to activate');
        return 'User account is deactivated, contact the operator to activate';
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      // Store user details in SharedPreferences
      SharedPreferencesService prefs =
          await SharedPreferencesService.getInstance();
      prefs.saveUserData({
        'uid': documentId ?? '',
        'email': userData['email'] ?? '',
        'displayName': userData['displayName'] ?? '',
        'photoURL': userData['photoURL'] ?? '',
        'phoneNum': userData['phoneNum'] ?? '',
        'createdAt':
            (userData['createdAt'] as Timestamp).toDate().toIso8601String(),
        'address': userData['address'] ?? '',
        'type': userData['type'] ?? '',
        'status': userData['status'] ?? '',
      });

      return null; // Sign-in successful
    } on FirebaseAuthException catch (e) {
      print('Caught FirebaseAuthException: ${e.code}');
      print('Error message: ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          //('User not found');
          print('Something went wrong: $e');
          return 'User not found';
        //break;
        case 'invalid-credential':
          //flutterToastError('Incorrect password');
          print('Something went wrong: $e');
          return 'Incorrect password';
        //break;
        case 'user-disabled':
          //flutterToastError('User account has been disabled');\
          print('Something went wrong: $e');
          return 'User account has been disabled';
        //break;
        case 'invalid-email':
          //flutterToast('The email address is not valid.');
          print('Something went wrong: $e');
          return 'The email address is not valid.';
        default:
          //flutterToastError('Something went wrong, please try again');
          print('Something went wrong: $e');
          return 'Something went wrong, please try again';
        //break;
      }
      throw (e.code);
    } catch (e) {
      print('Something went wrong: $e');
      //flutterToastError('Something went wrong, please try again');
      return 'Something went wrong, please try again';
      //throw Exception('Something went wrong: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    SharedPreferencesService prefs =
        await SharedPreferencesService.getInstance();
    _clearUserData(prefs);
  }

  // Clear user data from SharedPreferences
  void _clearUserData(SharedPreferencesService prefs) {
    prefs.saveData('uid', '');
    prefs.saveData('email', '');
    prefs.saveData('displayName', '');
    prefs.saveData('photoURL', '');
    prefs.saveData('phoneNum', '');
    prefs.saveData('createdAt', '');
    prefs.saveData('address', '');
    prefs.saveData('type', '');
    prefs.saveData('status', '');
  }

  //forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      flutterToast('Password reset has been sent to your email.');
    } catch (e) {
      print('Something went wrong: $e');
      flutterToast('Something went wrong, please try again');
    }
  }
}
