import 'package:chat_app/core/routes/routes_name.dart';
import 'package:chat_app/views/auth_folder/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final _authService = AuthServices();
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
                child: Icon(
                  Icons.chat,
                  size: 50.sp,
                  color: drawerTheme.background,
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
