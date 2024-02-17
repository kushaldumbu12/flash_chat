// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO : CREATE CHAT CARDS

class Chats extends StatefulWidget {
  const Chats({super.key});
  static String path = "chats";
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late User? loggedInUser;
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    try {
      loggedInUser = _auth.currentUser;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 2.0,
        leadingWidth: 40.0,
        leading: const Image(
          height: 5.0,
          image: AssetImage("images/flash.png"),
        ),
        title: const Text(
          " Chats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            iconColor: Colors.white,
            iconSize: 30.0,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                  value: 'logout', child: Text('Logout')),
              const PopupMenuItem<String>(
                  value: 'settings', child: Text('Settings')),
              const PopupMenuItem<String>(
                  value: 'newGroup', child: Text('New Group')),
              const PopupMenuItem<String>(
                  value: 'addFriend', child: Text('New Chat')),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'logout':
                  {
                    await _auth.signOut();
                    logoutUser();
                  }
              }
            },
          )
        ],
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  void logoutUser() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
