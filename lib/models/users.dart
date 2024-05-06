import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.bio,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  static User fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
      username: snap['username'],
      uid: snap['uid'],
      email: snap['email'],
      photoUrl: snap['photoUrl'],
      bio: snap['bio'],
      followers: snap['followers'],
      following: snap['following'],
    );
  }
}