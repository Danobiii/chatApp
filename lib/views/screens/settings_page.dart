import 'package:chat_app/core/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final width = 250.w;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(),

      body: Center(
        // margin: EdgeInsets.all(50),
        // padding: EdgeInsets.all(25),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).colorScheme.secondary,
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: GestureDetector(
          onTap: () {
            context.read<ThemeProvider>().toggleButton();
          },
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 700),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.lightGreenAccent : Colors.grey,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                width: width,
                height: 50.h,
                child: Center(
                  child: Text(
                    isDarkMode ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: 0,
                bottom: 0,
                left: isDarkMode ? 8 : width - 43,
                duration: Duration(milliseconds: 700),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    height: 35.h,
                    width: 35.w,
                    child: Icon(isDarkMode ? Icons.dark_mode : Icons.sunny),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
