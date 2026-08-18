import 'package:chat_app/core/components/my_drawer.dart';
import 'package:chat_app/core/components/search_widget.dart';
import 'package:chat_app/core/components/user_tile.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/services/chat/auth_services.dart';
import 'package:chat_app/views/auth_folder/main_page.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //chat and auth service
  final ChatServices _chatService = ChatServices();

  final AuthServices _authService = AuthServices();
  String searchText = "";
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
      body: Column(
        children: [
          Container(
            child: SearchWidget(
              searchIcon: Icon(Icons.search),
              text: "search users....",

              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading....");
        }
        List<Map<String, dynamic>> users = snapshot.data!;
        List filteredUsers = users.where((user) {
          return user["email"].toLowerCase().contains(searchText);
        }).toList();
        //return list view
        return ListView(
          children: filteredUsers
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
    //build chatroom
    String currentUserID = _authService.getCurrentuser()!.uid;
    List<String> ids = [currentUserID, userData["uid"]];
    ids.sort();
    String chatRoomID = ids.join("_");
    //diplay all users except current user
    if (userData["email"] != _authService.getCurrentuser()!.email) {
      // print("current user: ${_authService.getCurrentuser()!.email}");
      // print("userData email: ${userData["email"]}");
      return StreamBuilder(
        stream: _chatService.getUnreadMessageCount(chatRoomID, currentUserID),
        builder: (context, snapshot) {
          int unreadCount = snapshot.data ?? 0;
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
            unreadCount: unreadCount,
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
