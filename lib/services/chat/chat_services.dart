import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatServices {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _typingStatus = FirebaseDatabase.instance;
  // getuser stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().asyncMap((
      snapshot,
    ) async {
      //get all users from firestore
      List<Map<String, dynamic>> users = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data();
        String uid = userData['uid'];

        // get isOnline from Realtime Database for each user
        DatabaseEvent event = await FirebaseDatabase.instance
            .ref()
            .child('status')
            .child(uid)
            .once();
        bool isOnline = false;
        if (event.snapshot.exists) {
          Map status = event.snapshot.value as Map;
          isOnline = status['isOnline'] ?? false;
        }
        //combine firestore data with online status
        userData['isOnline'] = isOnline;
        users.add(userData);
      }
      return users;
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    //string and !
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      messages: message,
      timeStamp: timeStamp,
      receiverID: receiverID,
      isRead: false,
    );

    //chat room id for two users
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    //add new messages to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
    print("send RoomId: $chatRoomID");
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];

    ids.sort();
    String chatRoomID = ids.join("_");
    print("Get roomID: $chatRoomID");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  //function that writes to database
  Future<void> setTypingStatus(
    String chatRoomID,
    String userUID,
    bool isTyping,
  ) async {
    DatabaseReference userTypingStatus = _typingStatus
        .ref()
        .child('typing')
        .child(chatRoomID)
        .child(userUID);
    await userTypingStatus.update({"isTyping": isTyping});
  }

  //function that reads from database
  Stream<bool> getTypingStatus(String chatRoomID, String receiverUID) {
    return FirebaseDatabase.instance
        .ref()
        .child('typing')
        .child(chatRoomID)
        .child(receiverUID)
        .onValue
        .map((event) {
          if (event.snapshot.exists) {
            Map status = event.snapshot.value as Map;
            return status['isTyping'] ?? false;
          }
          return false;
        });
  }

  Future<void> markMessagesAsRead(
    String chatRoomID,
    String currentUserID,
  ) async {
    QuerySnapshot unreadMessages = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("isRead", isEqualTo: false)
        .where("receiverID", isEqualTo: currentUserID)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({"isRead": true});
    }
  }
}
