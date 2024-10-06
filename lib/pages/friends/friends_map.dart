import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsMapScreen extends StatefulWidget {
  @override
  _FriendsMapScreenState createState() => _FriendsMapScreenState();
}

class _FriendsMapScreenState extends State<FriendsMapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  void loadFriendsLocations() async {
    String currentUserId = 'your_current_user_id';
    var friendsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    var friendsList = friendsSnapshot['friends'];

    for (var friendId in friendsList) {
      var friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();

      if (friendDoc.exists && friendDoc['locationSharing'] == true) {
        var location = friendDoc['location'];
        _markers.add(Marker(
          markerId: MarkerId(friendId),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: friendDoc['name']),
        ));
        setState(() {}); // Refresh the map with new markers
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadFriendsLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Friends' Locations")),
      body: GoogleMap(
        onMapCreated: (controller) => _controller = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(15.7268212, 120.9249773), // Set to current location or center
          zoom: 10,
        ),
        markers: _markers,
      ),
    );
  }
}
