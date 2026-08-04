import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseDatabase _userStatus = FirebaseDatabase.instance;
  //get current user
  User? getCurrentuser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user if it does not exist
      await _fireStore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        "email": email,
        "isOnline": true,
      }, SetOptions(merge: true));
      //get reference to realtime database
      DatabaseReference userStatusRef = _userStatus
          .ref()
          .child('status')
          .child(userCredential.user!.uid);

      //tel firebase what to d when a user disconnects
      userStatusRef.onDisconnect().update({"isOnline": false});
      //set online in realtim database
      userStatusRef.update({"isOnline": true});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Session expiration
  Future<void> sessionExpiration() async {
    final user = _auth.currentUser;
    if (user != null) {
      final tokenResult = await user.getIdTokenResult();
      final authTime = tokenResult.authTime;
      final difference = DateTime.now().difference(authTime!);
      if (difference.inMinutes >= 3) {
        await _auth.signOut();
      }
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print("User created in Auth: ${userCredential.user!.uid}");

      //save user info
      await _fireStore.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        "email": email,
      });
      print("User saved to Firestore ✅");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Auth error: ${e.code}");

      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    await _fireStore.collection("Users").doc(_auth.currentUser!.uid).update({
      "isOnline": false,
    });
    return await _auth.signOut();
  }

  Future<String?> uploadPFP() async {
    //pick image from gallery
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      //return null if user cancel
      if (image == null) return null;
      //upload to cloudinary
      final cloudinary = CloudinaryPublic('geegypvd', "chat_app_preset");

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: "profile_pictures"),
      );
      print('cloudinary image: ${response.secureUrl}');

      //download URL
      String downloadURL = response.secureUrl;
      //save URL to firestore
      final String uid = _auth.currentUser!.uid;
      await _fireStore.collection("Users").doc(uid).update({
        "profilePictureUrl": downloadURL,
      });
      return downloadURL;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<String?> getProfilePicture() async {
    String? uid = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _fireStore.collection("Users").doc(uid).get();
    return doc["profilePictureUrl"];
  }
}
