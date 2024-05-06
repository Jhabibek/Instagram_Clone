import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethod {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //upload post data
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "some error occurred";

    try {
      String postId = const Uuid().v1(); // to create time-based IDs
      String photoUrl =
          await StorageMethod().uploadImageToStorage("post", file, true);

      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      await _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // For like Posts
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(
        error.toString(),
      );
    }
  }

  //comment purpose
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("Text is Empty");
      }
    } catch (error) {
      print(
        error.toString(),
      );
    }
  }
  //delete post purpose

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(
        error.toString(),
      );
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
