import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flash_chat/screens/welcome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'profile_screen.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});
  static String path = "chatwindow";

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String loggedInUserEmail;
  final textController = TextEditingController();
  Map<String, Map<String, dynamic>> colors = {};
  late String textMessage;
  List messages = [];
  List<String> tokens = [];
  bool gotColors = false;
  String groupName = 'Group name';
  String profileImageURL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:'
      'ANd9GcSLIZ64yKukHECxAk7-njzpPmBCUsEZLYgviA&usqp=CAU';
  bool gotGroupinfo = false;
  bool gotData = false;

  void getColors() async {
    var users = await _firestore.collection('users').get();
    for (var user in users.docs) {
      int color = user.data()['color'];
      String username = user.data()['username'];
      String email = user.data()['email'];
      colors[email] = {
        'username': username,
        'color': color,
      };
    }
    gotColors = true;
    setState(() {});
  }

  Future<void> sendPushNotification(String? sender, String message) async {
    var body = {
      "registration_ids": [tokens],
      "notification": {"body": message, "title": sender}
    };
    var response = await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'key=AAAAJMSSekw:APA91bHGUgfIAPSX-Qt5UKw-EglL6MY0uVL6xXhfBFZqDvvEeC4'
                '_pfVgm1sRE_Fc3mOMZ3EmcrokFlXGqd7B6MTiXTX-w2pBFhwt-ynIhV8llZrSie'
                'LXR0jy0WmMhuaGGPYqSSnEVR-7',
      },
      body: jsonEncode(body),
    );
    print(response.statusCode);
  }

  int getUserColor(String email) {
    return colors[email]!['color'];
  }

  void getTokens() async {
    var tokenShot = await _firestore.collection('tokens').get();
    for (var token in tokenShot.docs) {
      tokens.add(token.data()['token']);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getColors();
    getGroupDetails();
    getTokens();
  }

  void getGroupDetails() async {
    var ref = await _firestore.collection('group_info').get();
    var group = ref.docs.first;
    groupName = group.data()['name'];
    profileImageURL = group.data()['image'];
    setState(() {
      gotGroupinfo = true;
    });
  }

  void getCurrentUser() {
    try {
      var loggedInUser = _auth.currentUser?.email;
      loggedInUserEmail = loggedInUser!;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void logoutUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const Welcome()),
      ModalRoute.withName(Welcome.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 2.0,
        leadingWidth: 40.0,
        leading: CircleAvatar(
          radius: 10.0,
          backgroundImage: NetworkImage(profileImageURL),
        ),
        title: Text(
          groupName,
          style: const TextStyle(
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
                  value: 'groupInfo',
                  child: Hero(tag: 'groupInfo', child: Text('Group Details'))),
              const PopupMenuItem<String>(
                  value: 'settings', child: Text('Settings')),
              const PopupMenuItem<String>(
                  value: 'logout', child: Text('Logout')),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'logout':
                  {
                    await _auth.signOut();
                    logoutUser();
                  }
                case 'groupInfo':
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          groupName: groupName,
                          imageURL: profileImageURL,
                        ),
                      ),
                    );
                  }
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment
                    .bottomCenter, // Change this to create a vertical gradient
                colors: [
                  Color.fromRGBO(214, 241, 242,
                      0.5), // Equivalent to hsla(186, 33%, 94%, 1)
                  Color.fromRGBO(181, 198, 224,
                      0.5), // Equivalent to hsla(216, 41%, 79%, 1)
                ],
              ),
            ),
            child: Center(
              child: Image.asset(
                'images/flash (1).png',
                width: 400.0,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> message = [];
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Object?>>? messages =
                          snapshot.data?.docs;
                      for (var msg in messages!) {
                        final String sender = msg.get('sender');
                        final String messageText = msg.get('message');
                        final Timestamp stamp = msg.get('time');
                        final int color = getUserColor(sender);
                        final String time =
                            '${stamp.toDate().hour}:${stamp.toDate().minute}';
                        bool isMe = sender == loggedInUserEmail ? true : false;
                        message.add(
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color:
                                        gotColors ? Color(color) : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        time,
                                        textAlign: isMe
                                            ? TextAlign.end
                                            : TextAlign.start,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Flexible(
                                        child: Text(
                                          messageText,
                                          softWrap: true,
                                          maxLines: 20,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return Expanded(
                      child: ListView(
                        //reverse: true,
                        children: message,
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          textMessage = value;
                        },
                        controller: textController,
                        cursorColor: Colors.grey.shade600,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          fillColor: Colors.grey.shade600,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade600, width: 1.0),
                          ),
                          hintText: "Enter Message",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (textMessage.isNotEmpty) {
                            await _firestore.collection('messages').add({
                              'message': textMessage,
                              'sender': loggedInUserEmail,
                              'time': DateTime.timestamp(),
                            });
                            sendPushNotification(
                                loggedInUserEmail, textMessage);
                          }
                          textMessage = '';
                          setState(() {
                            textController.clear();
                          });
                        },
                        child: const Icon(Icons.send,
                            size: 30.0, color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
