import 'package:chat_app/core/components/chat_bubble.dart';
import 'package:chat_app/core/components/my_textfield.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/services/chat/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isSameday(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _previewText(Map<String, dynamic> data) {
    if (data["type"] == "image") return "photo";
    if (data["type"] == "video") return "video";
    return (data["messages"] ?? "").toString();
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;

    if (diff == 0) {
      return "Today";
    }
    if (diff == 1) {
      return "Yesterday";
    }
    const months = [
      "Jan",
      "Feb",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "Nov",
      "Dec",
    ];
    return "${date.day}, ${months[date.month - 1]}, ${date.year}";
  }

  void _pinMessageToTheTop(
    DocumentSnapshot doc,
    String message,
    String chatRomID,
  ) async {
    setState(() {});
  }

  void _showEditDialog(
    DocumentSnapshot doc,
    String currentText,
    String chatRoomID,
  ) async {
    final editController = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Edit message"),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),

            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final newText = editController.text.trim();
              Navigator.pop(dialogContext);
              if (newText.isEmpty || newText == currentText) return;

              await _chatService.editMessage(
                messageId: doc.id,
                chatRoomID: chatRoomID,
                newText: newText,
              );
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeperation(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 53, 51, 51),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  Map<String, dynamic>? _replyingTo;
  Widget _buildReplyWidget() {
    final reply = _replyingTo;
    if (reply == null) return SizedBox.shrink();
    final myUid = _authServices.getCurrentuser()!.uid;
    final who = reply["senderID"] == myUid ? "You" : widget.receiverEmail;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        border: const Border(left: BorderSide(color: Colors.green, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  who,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reply["text"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _replyingTo = null;
              });
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyQuote(Map<String, dynamic> data) {
    if (data["replyToId"] == null) return const SizedBox.shrink();

    final myUid = _authServices.getCurrentuser()!.uid;
    final who = data["replyToSenderID"] == myUid ? "You" : widget.receiverEmail;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        border: const Border(left: BorderSide(color: Colors.green, width: 3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            who,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data["replyToText"] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
  //   Widget _buildReplyQuote(Map<String, dynamic> data) {
  //   if (data["replyToId"] == null) return const SizedBox.shrink();

  //   final myUid = _authServices.getCurrentuser()!.uid;
  //   final who = data["replyToSenderID"] == myUid ? "You" : widget.receiverEmail;

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 2),
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade800,
  //       border: const Border(
  //         left: BorderSide(color: Colors.green, width: 3),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           who,
  //           style: const TextStyle(
  //             color: Colors.green,
  //             fontSize: 11,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         Text(
  //           data["replyToText"] ?? "",
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: Colors.white, fontSize: 12),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildReactions(Map<String, dynamic> data) {
    final reactions = Map<String, dynamic>.from(data['reactions'] ?? {});
    if (reactions.isEmpty) return const SizedBox.shrink();

    final counts = <String, int>{};
    for (final emoji in reactions.values) {
      counts[emoji as String] = (counts[emoji] ?? 0) + 1;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: 4,
        children: counts.entries.map((e) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              e.value > 1 ? '${e.key} ${e.value}' : e.key,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  //text controller
  final _messageController = TextEditingController();

  final ChatServices _chatService = ChatServices();

  final AuthServices _authServices = AuthServices();

  XFile? _pendingMedia;
  String? _pendingMediaType;

  void _pickMedia() async {
    final file = await _chatService.pickMedia();
    if (file != null) {
      final String? mimeType = file.mimeType;
      final bool isVideo = mimeType != null && mimeType.startsWith("video");
      setState(() {
        _pendingMedia = file;
        _pendingMediaType = isVideo ? "video" : "image";
      });
    }
  }

  void _sendPendingMedia() async {
    if (_pendingMedia != null) {
      await _chatService.sendMediaMessage(
        widget.receiverID,
        _pendingMedia!,
        _pendingMediaType!,
      );
      setState(() {
        _pendingMedia = null;
        _pendingMediaType = null;
      });
      scrollDown();
    }
  }

  void _cancelPendingMedia() {
    setState(() {
      _pendingMedia = null;
      _pendingMediaType = null;
    });
  }

  //textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

    //user typing status
    String currentUserID = _authServices.getCurrentuser()!.uid;
    List<String> ids = [currentUserID, widget.receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty) {
        _chatService.setTypingStatus(chatRoomID, currentUserID, true);
      } else {
        _chatService.setTypingStatus(chatRoomID, currentUserID, false);
      }
    });

    //mark messages as read when chat opens
    _chatService.markMessagesAsRead(chatRoomID, currentUserID);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //func to send mesage
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final reply = _replyingTo;
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
        replyTo: reply,
      );
      if (!mounted) return;
      setState(() => _replyingTo = null);

      //clear text controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = _authServices.getCurrentuser()!.uid;
    List<String> ids = [currentUserId, widget.receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          StreamBuilder<bool>(
            stream: _chatService.getTypingStatus(chatRoomID, widget.receiverID),
            builder: (context, snapshot) {
              bool isTyping = snapshot.data ?? false;
              if (isTyping) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.receiverEmail} is typing...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildMediaPreview(),
          _buildReplyWidget(), // new

          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentuser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return Text("error:${snapshot.error}");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        //double tick when inside chatpage
        List<String> ids = [senderID, widget.receiverID];
        ids.sort();
        String chatRoomID = ids.join("_");
        _chatService.markMessagesAsRead(chatRoomID, senderID);
        final docs = snapshot.data!.docs;
        return ListView.builder(
          controller: _scrollController,
          itemCount: docs.length,

          itemBuilder: (BuildContext context, int index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            final date = (data["timeStamp"] as Timestamp?)?.toDate();
            var showSeperator = false;
            if (date != null) {
              if (index == 0) {
                showSeperator = true;
              } else {
                final prev = docs[index - 1].data() as Map<String, dynamic>;
                final prevDate = (prev["timeStamp"] as Timestamp?)?.toDate();
                showSeperator = prevDate == null || !_isSameday(date, prevDate);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showSeperator && date != null)
                  _buildDateSeperation(_dateLabel(date)),
                _buildMessageItem(doc),
              ],
            );
          },

          // children: snapshot.data!.docs
          //     .map((doc) => _buildMessageItem(doc))
          //     .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final isEdited = data["edited"] == true;
    final isMessagePinned = data["isPinned"] == true;

    bool isCurrentUser =
        data["senderID"] == _authServices.getCurrentuser()!.uid;
    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _buildReplyQuote(data),
          GestureDetector(
            onLongPress: () {
              final data = doc.data() as Map<String, dynamic>;
              final reactions = Map<String, dynamic>.from(
                data["reactions"] ?? {},
              );
              final myUid = _authServices.getCurrentuser()!.uid;
              final myReactions = reactions[myUid] as String?;
              final ids = [myUid, widget.receiverID]..sort();
              final chatRoomID = ids.join("_");
              showDialog(
                context: context,
                builder: (dialogContext) => Dialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          children:
                              [
                                '👍',
                                '❤️',
                                '😂',
                                '😮',
                                '😢',
                                '🙏',
                                '🔥',
                                '🎉',
                              ].map((emoji) {
                                final selected = emoji == myReactions;
                                return GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(dialogContext);
                                    await _chatService.emojiReactions(
                                      messageId: doc.id,
                                      chatRoomID: chatRoomID,
                                      emoji: emoji,
                                      currentReaction: myReactions,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected
                                          ? Colors.green.withOpacity(0.25)
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const Divider(height: 24),
                        //reply button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            setState(() {
                              _replyingTo = {
                                "id": doc.id,
                                "senderID": data["senderID"],
                                "text": _previewText(data),
                              };
                            });
                            myFocusNode.requestFocus();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.reply),
                              SizedBox(width: 8),
                              Text("Reply"),
                            ],
                          ),
                        ),
                        //cancel button
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cancel),
                              SizedBox(width: 8),
                              Text("Cancel"),
                            ],
                          ),
                        ),
                        if (isCurrentUser &&
                            data["type"] != "image" &&
                            data["type"] != "video")
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _showEditDialog(
                                doc,
                                (data["messages"] ?? ""),
                                chatRoomID,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.edit), Text("Edit")],
                            ),
                          ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await _chatService.pinMessage(
                              messageId: doc.id,
                              chatRoomID: chatRoomID,
                              pinState: !isMessagePinned,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.push_pin),
                              Text(isMessagePinned ? "Unpin" : "Pin"),
                            ],
                          ),
                        ),
                        //copy button
                        TextButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: data["messages"]),
                            );
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied")),
                            );
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy),
                              SizedBox(width: 8),
                              Text("Copy"),
                            ],
                          ),
                        ),
                        //delete button
                        if (isCurrentUser)
                          TextButton(
                            onPressed: () {
                              if (!isCurrentUser) return;
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete Message?"),
                                  content: Text(
                                    "Are you sure you want to delete message?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    if (isCurrentUser) ...[
                                      TextButton(
                                        onPressed: () async {
                                          List<String> ids = [
                                            _authServices.getCurrentuser()!.uid,
                                            widget.receiverID,
                                          ];
                                          ids.sort();
                                          String chatRoomID = ids.join("_");
                                          //delete message
                                          if (isCurrentUser) {
                                            await _chatService.deleteMessage(
                                              doc.id,
                                              chatRoomID,
                                            );
                                          }
                                          if (!context.mounted) return;
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 8.w),
                                Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: data["type"] == "image"
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      data["mediaURL"],
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : data["type"] == "video"
                ? Container(
                    width: 200,
                    height: 150,
                    color: Colors.black12,
                    child: const Icon(Icons.play_circle_fill, size: 50),
                  )
                : ChatBubble(
                    message: data["messages"],
                    isCurrentUser: isCurrentUser,
                    isRead: data["isRead"] ?? false,
                  ),
          ),
          _buildReactions(data),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "${isEdited ? "edited." : ""} ${_formatTimestamp(data["timeStamp"])}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}";
  }

  Widget _buildMediaPreview() {
    if (_pendingMedia == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _pendingMediaType == "image"
              ? Image.file(
                  File(_pendingMedia!.path),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.videocam, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_pendingMedia!.name, overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelPendingMedia,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendPendingMedia,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _pickMedia(),
          ),
          Expanded(
            child: MyTextfield(
              hintText: "Type a message",
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}
