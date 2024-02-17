import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'package:flash_chat/components/flash_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//STATUS : COMPLETE

class Welcome extends StatefulWidget {
  static String path = "welcome";

  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late final String photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Hero(
                tag: 'logo',
                child: Image(
                  image: AssetImage(
                    "images/flash.png",
                  ),
                  height: 75.0,
                ),
              ),
              const SizedBox(
                width: 25.0,
              ),
              Flexible(
                child: SizedBox(
                  width: 300.0,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Flash Chat",
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 250),
                      ),
                    ],
                    pause: const Duration(seconds: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          Hero(
            tag: "login",
            child: FlashButton(
                title: "LOGIN",
                onPressed: () => Navigator.pushNamed(context, Login.path)),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Hero(
            tag: "signup",
            child: FlashButton(
              title: "SIGN UP",
              onPressed: () {
                Navigator.pushNamed(context, SignUp.path);
              },
            ),
          ),
        ],
      ),
    );
  }
}
