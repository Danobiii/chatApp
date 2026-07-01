import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final  Function(String)? onChanged;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const MyTextfield({super.key, required this.hintText, required this.obscureText, required this.controller, this.onChanged, this.focusNode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        focusNode: focusNode,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textTheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textTheme.primary),
          ),
          fillColor: textTheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: textTheme.primary),
          
        ),
      ),
    );
  }
}
