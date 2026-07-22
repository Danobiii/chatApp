import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          Text(message),

          if (isCurrentUser)
            Icon(
              isRead ? Icons.done_all : Icons.done,
              size: 14,
              color: isRead ? Colors.blue : Colors.white,
            ),
        ],
      ),
    );
  }
}
