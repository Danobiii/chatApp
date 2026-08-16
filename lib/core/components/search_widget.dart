import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidget extends StatelessWidget {
  final Icon searchIcon;
  final String text;
  final Function(String) onChanged;
  const SearchWidget({
    super.key,
    required this.searchIcon,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.black,
        hintText: text,
        suffixIcon: searchIcon,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
