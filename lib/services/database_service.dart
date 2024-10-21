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

import '../api/firebase_api.dart';
import '../pages/login_page.dart';
import 'foreground_service.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveFcmToken(String userId) async {
    try {
      final FirebaseApi firebaseApi = FirebaseApi();
      await firebaseApi.initNotifications(userId);
    } catch (e) {
      print('Failed to save FCM token: $e');
    }
  }

// Add SOS data to the current user's Firestore document
  Future<void> addSosToUser(String userId, GeoPoint location) async {
    try {
      // Reference to the current user's document in the 'citizens' collection
      final userDocRef = _db.collection('citizens').doc(userId);

      // Generate a client-side timestamp using DateTime.now()
      final timestamp = DateTime.now();

      // Prepare the SOS data with the same client-side timestamp
      final sosData = {
        'location': location,
        'createdAt': timestamp, // Client-side timestamp used here
      };

      // Use set() with merge: true and arrayUnion to append SOS data
      await userDocRef.set({
        'sos': FieldValue.arrayUnion([sosData])
      }, SetOptions(merge: true));

      print("SOS data added to user document with client-side timestamp.");
    } catch (e) {
      print("Error adding SOS data: $e");
      throw e;
    }
  }

  // Getter for the current user
  User? get currentUser {
    return _auth.currentUser;
  }

  /// Method to add or update a document with dynamic fields
  Future<void> setDocument(
      String collection, String docId, Map<String, dynamic> data,
      {bool merge = true}) async {
    try {
      _checkAuthentication();
      await _db
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
      print("Document set successfully!");
    } catch (e) {
      print("Error setting document: $e");
    }
  }

  /// Method to retrieve a document with dynamic fields
  Future<Map<String, dynamic>?> getDocument(String collection) async {
    try {
      // Ensure the user is authenticated
      final user = _auth.currentUser;
      if (user == null) {
        print("User is not authenticated!");
        return null;
      }
      _checkAuthentication();
      DocumentSnapshot document =
          await _db.collection(collection).doc(user.uid).get();
      if (document.exists) {
        return document.data() as Map<String, dynamic>?;
      } else {
        print("Document does not exist!");
        return null;
      }
    } catch (e) {
      print("Error fetching document: $e");
      return null;
    }
  }

  /// Method to update specific fields in a document with dynamic fields
  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    try {
      _checkAuthentication();
      await _db.collection(collection).doc(docId).update(data);
      print("Document updated successfully!");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  /// Method to delete a document or specific fields from a document
  Future<void> deleteFields(
      String collection, String docId, List<String> fields) async {
    try {
      _checkAuthentication();
      Map<String, dynamic> updates = {};
      for (String field in fields) {
        updates[field] = FieldValue.delete();
      }
      await _db.collection(collection).doc(docId).update(updates);
      print("Fields deleted successfully!");
    } catch (e) {
      print("Error deleting fields: $e");
    }
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

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

// Method to update or create locationSharing, latitude, longitude, and lastUpdated fields
  Future<void> updateLocationSharing({
    required GeoPoint location, // Use GeoPoint here
    required bool locationSharing, // New parameter for locationSharing
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final userRef = _db.collection('citizens').doc(user.uid);

      // Set the locationSharing, location, and lastUpdated fields (creates if not exist)
      await userRef.set(
          {
            'locationSharing': locationSharing, // Enable location sharing
            'location': location, // Store as GeoPoint
            'lastUpdated': FieldValue
                .serverTimestamp(), // Update the last updated timestamp
          },
          SetOptions(
              merge: true)); // Merge to ensure fields are created if not exist
    } catch (e) {
      // Handle errors
      throw Exception('Error updating user location: $e');
    }
  }

  Future<DocumentSnapshot> getUserDoc(String uid) async {
    return await _db.collection('citizens').doc(uid).get();
  }

  Future<void> addReport({
    required String address,
    required String landmark,
    required String description,
    required String incidentType,
    required String injuredCount,
    required String seriousness,
    required GeoPoint location, // Use GeoPoint here
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
        'responderTeam': null,
        'timestamp': FieldValue.serverTimestamp(),
        'location': location, // Store as GeoPoint
        'status': 'pending',
      };

      await _db.collection('reports').add(reportData);
    } catch (e) {
      throw Exception('Failed to add report: $e');
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

  void redirectToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    SharedPreferencesService prefs =
        await SharedPreferencesService.getInstance();
    _clearUserData(prefs);
  }

//------------------------FRIENDS METHODS------------------------------------------------------------------------

// Search users by displayName and exclude current user and already friends
  Future<List<DocumentSnapshot>> searchUsers(String query) async {
    try {
      String? currentUserId = currentUser?.uid;

      if (currentUserId == null) {
        return []; // Handle case if the user is not authenticated
      }

      // Fetch the current user's document to get the list of friends
      DocumentSnapshot currentUserSnapshot =
          await _db.collection('citizens').doc(currentUserId).get();
      Map<String, dynamic>? currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> currentUserFriends = currentUserData?['friends'] ?? [];

      // Query to search users based on displayName
      QuerySnapshot usersSnapshot = await _db
          .collection('citizens')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      // Filter the results to exclude the current user and already friends
      List<DocumentSnapshot> filteredUsers = usersSnapshot.docs
          .where((doc) =>
              doc.id !=
                  currentUserId && // Exclude the current user by their UID
              !currentUserFriends
                  .contains(doc.id)) // Exclude users who are already friends
          .toList();

      return filteredUsers;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

// Send friend request and initialize pendingRequests if necessary
  Future<void> sendFriendRequest(String friendId) async {
    String? currentUserId = currentUser?.uid;
    if (currentUserId == null) {
      print('Unauthenticated user. Cannot send friend request.');
      return;
    }

    DocumentReference friendDocRef =
        _db.collection('citizens').doc(friendId); // Ensure correct collection

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot friendDocSnapshot =
            await transaction.get(friendDocRef);

        if (!friendDocSnapshot.exists) {
          print('Friend document does not exist');
          return;
        }

        Map<String, dynamic> friendData =
            friendDocSnapshot.data() as Map<String, dynamic>? ?? {};

        List<dynamic> pendingRequests = friendData['pendingRequests'] ?? [];

        // Check for duplicates
        if (pendingRequests.contains(currentUserId)) {
          print('Friend request already sent.');
          return;
        }

        // Add the request
        pendingRequests.add(currentUserId);

        transaction.update(friendDocRef, {
          'pendingRequests': pendingRequests,
        });
        print('Friend request sent successfully.');
      });
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

// Get pending friend requests
  Stream<DocumentSnapshot> getPendingRequests() {
    String? currentUserId = currentUser?.uid;
    if (currentUserId == null) {
      print('Unauthenticated user. Cannot get pending requests.');
      throw Exception('Unauthenticated user');
    }
    return _db.collection('citizens').doc(currentUserId).snapshots();
  }

// Accept friend request and initialize friends if necessary
  Future<void> acceptFriendRequest(String friendId) async {
    String? currentUserId = currentUser?.uid;
    if (currentUserId == null) {
      print('Unauthenticated user. Cannot accept friend request.');
      return;
    }

    DocumentReference currentUserRef =
        _db.collection('citizens').doc(currentUserId);
    DocumentReference friendDocRef = _db.collection('citizens').doc(friendId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnapshot =
            await transaction.get(currentUserRef);
        DocumentSnapshot friendDocSnapshot =
            await transaction.get(friendDocRef);

        if (!currentUserSnapshot.exists || !friendDocSnapshot.exists) {
          print('One of the documents does not exist.');
          return;
        }

        Map<String, dynamic> currentUserData =
            currentUserSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> friendData =
            friendDocSnapshot.data() as Map<String, dynamic>;

        List<dynamic> currentUserFriends = currentUserData['friends'] ?? [];
        List<dynamic> friendFriends = friendData['friends'] ?? [];
        List<dynamic> pendingRequests =
            currentUserData['pendingRequests'] ?? [];

        if (!currentUserFriends.contains(friendId)) {
          currentUserFriends.add(friendId);
        }

        if (!friendFriends.contains(currentUserId)) {
          friendFriends.add(currentUserId);
        }

        pendingRequests.remove(friendId);

        transaction.update(currentUserRef, {
          'friends': currentUserFriends,
          'pendingRequests': pendingRequests,
        });

        transaction.update(friendDocRef, {
          'friends': friendFriends,
        });

        print('Friend request accepted successfully.');
      });
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

// Decline friend request
  Future<void> declineFriendRequest(String friendId) async {
    String? currentUserId = currentUser?.uid;
    if (currentUserId == null) {
      print('Unauthenticated user. Cannot decline friend request.');
      return;
    }

    DocumentReference currentUserRef =
        _db.collection('citizens').doc(currentUserId);

    try {
      await _db.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnapshot =
            await transaction.get(currentUserRef);

        if (!currentUserSnapshot.exists) {
          print('User document does not exist.');
          return;
        }

        Map<String, dynamic> currentUserData =
            currentUserSnapshot.data() as Map<String, dynamic>;
        List<dynamic> pendingRequests =
            currentUserData['pendingRequests'] ?? [];

        pendingRequests.remove(friendId);

        transaction.update(currentUserRef, {
          'pendingRequests': pendingRequests,
        });

        print('Friend request declined successfully.');
      });
    } catch (e) {
      print('Error declining friend request: $e');
    }
  }

  // Fetch current user's friends
  Future<List<DocumentSnapshot>> getFriends() async {
    String? currentUserId = currentUser?.uid;
    DocumentSnapshot currentUserSnapshot =
        await _db.collection('citizens').doc(currentUserId).get();
    List<dynamic> friendsIds =
        (currentUserSnapshot.data() as Map<String, dynamic>)['friends'] ?? [];

    // Fetch friends' details
    if (friendsIds.isEmpty) return [];
    QuerySnapshot friendsSnapshot = await _db
        .collection('citizens')
        .where(FieldPath.documentId, whereIn: friendsIds)
        .get();
    return friendsSnapshot.docs;
  }

// Remove friend from both the user's and the friend's friends list
  Future<void> removeFriend(String friendId) async {
    String? currentUserId = currentUser?.uid;

    if (currentUserId == null) return;

    // Get references for both current user and the friend
    DocumentReference currentUserRef =
        _db.collection('citizens').doc(currentUserId);
    DocumentReference friendRef = _db.collection('citizens').doc(friendId);

    // Get current user's document
    DocumentSnapshot currentUserSnapshot = await currentUserRef.get();
    List<dynamic> currentUserFriends =
        (currentUserSnapshot.data() as Map<String, dynamic>)['friends'] ?? [];

    // Get friend's document
    DocumentSnapshot friendSnapshot = await friendRef.get();
    List<dynamic> friendFriends =
        (friendSnapshot.data() as Map<String, dynamic>)['friends'] ?? [];

    // Remove friend from current user's friends list
    currentUserFriends.remove(friendId);

    // Remove current user from friend's friends list
    friendFriends.remove(currentUserId);

    // Update both users' documents
    await currentUserRef.update({
      'friends': currentUserFriends,
    });

    await friendRef.update({
      'friends': friendFriends,
    });
  }

// ----------------------------------------------- NEW AND IMPROVED METHOD ABOVE ---------------------------------------------------------------

// ----------------------------------------------- OLD METHOD BELOW TO BE MIGRATE TO NEW ---------------------------------------------------------------
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

// Fetch announcements from Firestore
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting announcements: $e');
      return [];
    }
  }

  // Method to fetch the latest 3 announcements from the 'announcements' collection
  Future<List<Map<String, dynamic>>> getLatestAnnouncements() async {
    QuerySnapshot snapshot = await _db
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .limit(3)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Optional: include document ID if needed
      return data;
    }).toList();
  }

  // Method to fetch the latest 3 announcements from the 'posts' collection
  Future<List<Map<String, dynamic>>> getLatestPosts() async {
    QuerySnapshot snapshot = await _db
        .collection('posts')
        .orderBy('timestamp', descending: true) // Order by the latest posts
        .limit(3) // Fetch the latest 5 posts (adjust the limit as needed)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Function to fetch posts from Firestore
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      // Query the 'posts' collection in Firestore
      QuerySnapshot querySnapshot = await _db
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      // Map each document in the collection to a Map<String, dynamic>
      List<Map<String, dynamic>> posts = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return posts;
    } catch (e) {
      // Handle errors (e.g., show in UI or log)
      print('Error fetching posts: $e');
      return [];
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
      final documentId = docSnapshot.docs.first.id;
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

      // Save FCM token
      await saveFcmToken(documentId);

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
      // Save FCM token
      await saveFcmToken(documentId);

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
