import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isOnine;
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.isOnine,
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
            //icon
            // Icon(Icons.person),
            Stack(
              children: [
                Icon(Icons.person),
                //online indicator
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnine ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            //username
            Text(text),
          ],
        ),
      ),
    );
  }
}
