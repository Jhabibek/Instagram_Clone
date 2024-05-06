import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class Posts {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Posts(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImages": profImage,
        "likes": likes
      };

  static Posts fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Posts(
      username: snap['username'],
      uid: snap['uid'],
      description: snap['description'],
      postId: snap['postId'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      profImage: snap['profImage'],
      likes: snap['likes'],
    );
  }
}
