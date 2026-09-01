/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
admin.initializeApp;
// setGlobalOptions({maxInstances: 10});
export const newMessage = onDocumentCreated(
  "chat_rooms/{chatRoomID}/messages/{messageID}",
 async (event)=>{
    const messageData = event.data?.data();
        if (!messageData) {
      logger.warn("No message data found, skipping.");
      return;
    }
    logger.info("New message created!", {messageData: messageData});

    const receiverID = messageData.receiverID;
    const messageText = messageData.messages;
    if(!receiverID){
      logger.warn("Message has no receiverID");
      return;
    }
    const userDoc = await admin.firestore().collection("Users").doc(receiverID).get();
    const fcmToken = userDoc.data()?.["FCM TOKEN"];

    if(!fcmToken){
      logger.warn("No FCM token found for user ${receiverID}");
      return;
    }
    const payLoad = {
      token:fcmToken,
      notification:{
title: "New Message",
body:messageText || "You have a new message",
      },
    };
    try{
      const response = await admin.messaging().send(payLoad);
      logger.info("Notification sent successfully", {response});
    }catch(error){
logger.error("Error sending Notification", {error});
    }
  });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
