import 'package:chat_app/core/routes/routes_name.dart';
import 'package:chat_app/services/chat/auth_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _authService = AuthServices();
  String? _profilePicUrl;

  void logOut() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final drawerTheme = Theme.of(context).colorScheme;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //profile pic
                    GestureDetector(
                      onTap: () async {
                        String? url = await _authService.uploadPFP();
                        if (url != null) {
                          setState(() {
                            _profilePicUrl = url;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundImage: _profilePicUrl != null
                            ? NetworkImage(_profilePicUrl!)
                            : null,
                        child: _profilePicUrl == null
                            ? Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Tap to change Photo",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesName.homePage),
                  leading: Icon(
                    Icons.home,
                    color: drawerTheme.primary,
                    size: 30.sp,
                  ),
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: drawerTheme.primary,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.settingsPage);
                  },
                  leading: Icon(
                    Icons.settings,
                    color: drawerTheme.primary,
                    size: 30.sp,
                  ),
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: drawerTheme.primary,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              onTap: logOut,
              leading: Icon(
                Icons.logout,
                color: drawerTheme.primary,
                size: 30.sp,
              ),
              title: Text(
                "L O G O U T",
                style: TextStyle(color: drawerTheme.primary, fontSize: 15.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
