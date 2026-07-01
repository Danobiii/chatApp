import 'package:chat_app/views/auth_folder/auth_services.dart';
import 'package:chat_app/views/auth_folder/login_or_register_page.dart';
import 'package:chat_app/views/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // print("Builder running");
          // print(snapshot.connectionState);
          // print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData
          // && snapshot.data != null
          ) {
            // _authServices.sessionExpiration();
            // print("going to homepage");
            return HomePage();
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
