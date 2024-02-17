import 'package:flutter/material.dart';

class InputFieldDecoration {
  static InputDecoration textFieldDecoration(
      {required String hintText, required Icon icon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      fillColor: Colors.grey,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      ),
      iconColor: Colors.grey,
      icon: icon,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      border: const OutlineInputBorder(),
    );
  }
}
