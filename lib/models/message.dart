import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String messages;
  final Timestamp timeStamp;
  final String receiverID;
  final bool isRead;
  final String type;
  final String? mediaURL;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.messages,
    required this.timeStamp,
    required this.receiverID,
    required this.isRead,
    required this.type,
    required this.mediaURL,
  });
  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      "senderID": senderID,
      //check later
      // "receiverEmail": senderEmail,
      "senderEmail": senderEmail,
      "messages": messages,
      "timeStamp": timeStamp,
      "receiverID": receiverID,
      "isRead": isRead,
      "type": type,
      "mediaURL": mediaURL,
    };
  }
}
