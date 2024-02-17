import 'chatwindow.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/flash_button.dart';
import 'package:flash_chat/components/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'edit_profile.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String path = "signup";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String gmail;
  late String password;
  String errorMessage = "";

  void redirectPage() => Navigator.pushNamed(context, EditProfile.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25.0,
            color: Colors.black,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage(
                        "images/flash.png",
                      ),
                      height: 200.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: SizedBox(
                  width: 240.0,
                  child: TextField(
                    //Username input Action
                    onChanged: (value) async {
                      gmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    enabled: true,
                    cursorColor: Colors.lightBlueAccent,
                    decoration: InputFieldDecoration.textFieldDecoration(
                      hintText: "Username",
                      icon: const Icon(
                        Icons.person,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: SizedBox(
                  width: 240.0,
                  child: TextField(
                    //Password input Action
                    onChanged: (value) {
                      password = value;
                    },

                    obscureText: true,
                    textAlign: TextAlign.center,
                    enabled: true,
                    cursorColor: Colors.lightBlueAccent,
                    decoration: InputFieldDecoration.textFieldDecoration(
                      hintText: "Password",
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 25.0,
                ),
              ),
              Hero(
                tag: "signup",
                child: FlashButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    await _auth.createUserWithEmailAndPassword(
                        email: gmail, password: password);
                    redirectPage();
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  title: "SIGN UP",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
