import 'package:chat_app/views/screens/home_page.dart';
import 'package:chat_app/views/screens/settings_page.dart';
import 'package:flutter/material.dart';

class ChatAppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/homePage":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/settingsPage":
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("Route not Found"))),
        );
    }
  }
}
