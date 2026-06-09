import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String messages;
  final Timestamp timeStamp;
  final String receiverID;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.messages,
    required this.timeStamp,
    required this.receiverID,
  });
  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      "senderID": senderID,
      "receiverEmail": senderEmail,
      "messages": messages,
      "timeStamp": timeStamp,
      "receiverID": receiverID,
    };
  }
}
