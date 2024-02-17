import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  final void Function() onPressed;

  final String title;

  const FlashButton({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: Colors.lightBlueAccent,
        ),
        alignment: Alignment.center,
        width: 200.0,
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
