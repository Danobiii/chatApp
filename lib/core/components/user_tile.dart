import 'package:chat_app/core/components/online_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String uid;
  final int unreadCount;
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.uid,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    final userTileTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: userTileTheme.secondary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(Icons.person),
                //online indicator
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: OnlineDot(uid: uid, key: ValueKey(uid)),
                ),
              ],
            ),
            SizedBox(width: 20),
            //username
            Text(text),
            Spacer(),
            if (unreadCount > 0)
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
