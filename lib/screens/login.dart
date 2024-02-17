import 'chatwindow.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/flash_button.dart';
import 'package:flash_chat/components/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

//TODO VALIDATION

class Login extends StatefulWidget {
  const Login({super.key});
  static String path = "login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  String errorMessage = "";
  final usernameText = TextEditingController();
  final passwordText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                height: 30.0,
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
                    onChanged: (value) {
                      email = value;
                    },
                    controller: usernameText,
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
                    controller: passwordText,
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
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "login",
                  child: FlashButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          setState(() {
                            showSpinner = false;
                          });
                          redirectPage();
                        } on FirebaseAuthMultiFactorException {
                          setState(() {
                            clearText();
                            errorMessage = "Username or password is Invalid";
                            showSpinner = false;
                          });
                        }
                      },
                      title: "LOGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearText() {
    usernameText.clear();
    passwordText.clear();
  }

  void redirectPage() => Navigator.pushNamed(context, ChatWindow.path);
}
