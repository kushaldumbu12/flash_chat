import 'package:flash_chat/screens/chatwindow.dart';
import 'package:flash_chat/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoadingScreen extends StatefulWidget {
  static String path = 'LoadingScreen';
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoggedIn = false;
  bool checkStatus = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLoginStatus();
  }

  void userLoginStatus() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        isLoggedIn = true;
        checkStatus = true;
        redirect();
        setState(() {});
      }

      checkStatus = true;
      redirect();
    });
  }

  void redirect() {
    if (checkStatus) {
      if (isLoggedIn) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ChatWindow()),
            ModalRoute.withName(ChatWindow.path));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Welcome()),
            ModalRoute.withName(Welcome.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/flash.png'),
              height: 200,
            ),
            SizedBox(
              width: 200,
              height: 200,
              child: ModalProgressHUD(
                progressIndicator: const CircularProgressIndicator(
                  color: Colors.lightBlueAccent,
                ),
                color: Colors.white,
                inAsyncCall: !checkStatus,
                child: const SizedBox(
                  height: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
