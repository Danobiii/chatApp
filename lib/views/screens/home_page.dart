import 'package:chat_app/core/components/my_drawer.dart';
import 'package:chat_app/core/components/user_tile.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/views/auth_folder/auth_services.dart';
import 'package:chat_app/views/auth_folder/main_page.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat and auth service
  final ChatServices _chatService = ChatServices();
  final AuthServices _authService = AuthServices();
  //should be called in MyDrawer
  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // final homePageTheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading....");
        }

        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    //diplay all users except current user
    if (userData["email"] != _authService.getCurrentuser()!.email) {
      print("current user: ${_authService.getCurrentuser()!.email}");
      print("userData email: ${userData["email"]}");
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tap on a user ->> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
        isOnine: userData["isOnline"] ?? false,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
