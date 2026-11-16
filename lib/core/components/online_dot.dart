import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OnlineDot extends StatefulWidget {
  final String uid;

  const OnlineDot({super.key, required this.uid});

  @override
  State<OnlineDot> createState() => _OnlineDotState();
}

class _OnlineDotState extends State<OnlineDot> {
  late final Stream<DatabaseEvent> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseDatabase.instance
        .ref('status/${widget.uid}/isOnline')
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        final isOnline = snapshot.data?.snapshot.value == true;
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
