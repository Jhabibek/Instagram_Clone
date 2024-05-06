import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/users.dart' as model;
import 'package:instagram_clone/resources/storage_method.dart';

class AuthMethod {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _firebaseAuth.currentUser!;

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnapshot(snapshot);
  }

  //sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register the user
        UserCredential cred = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilePics', file, false);

        //add user to our database

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firebaseFirestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    }
    // for custom error messages
    // on FirebaseAuthException catch(e){
    //   if(e.code == 'invalid-email'){
    //     res = 'The email is badly formatted.';
    //   }
    // }
    catch (e) {
      res = e.toString();
    }
    return res;
  }

  //log in user

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //sign out user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
