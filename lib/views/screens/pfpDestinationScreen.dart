import 'package:flutter/material.dart';

class Pfpdestinationscreen extends StatelessWidget {
  final String imageUrl;
  const Pfpdestinationscreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,

        // elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: "pfp",
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
