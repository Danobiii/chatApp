import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
}
