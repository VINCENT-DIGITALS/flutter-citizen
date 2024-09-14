import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountDetails {
  String name;
  String email;
  Timestamp createdOn;
  Timestamp updatedOn;
  String photoUrl;



  CreateAccountDetails({
  required this.name,
  required this.email,
  required this.createdOn,
  required this.updatedOn,
  required this.photoUrl,


});

  CreateAccountDetails.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          createdOn: json['createdOn']! as Timestamp,
          updatedOn: json['updatedOn']! as Timestamp,
          photoUrl: json['photoUrl']! as String,
        );

    CreateAccountDetails copyWith({
    String? name,
    String? email,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    String? photoUrl,
  }) {
    return CreateAccountDetails(
        name: name ?? this.name,
        email: email ?? this.email,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn,
        photoUrl: photoUrl ?? this.photoUrl,
        );
  }

  Map<String, Object?> toJson() {
    return {
      'username': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}