import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/user_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String groupName;
  final String imageURL;
  const Profile({super.key, required this.groupName, required this.imageURL});

  static String path = 'profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final User? user;
  List<Container> userItems = [];
  late String groupDp;
  bool listOpen = false;
  String groupName = "GroupName";
  bool isImage = false;
  late ImageProvider image;

  late AnimationController slideDownController;

  late String profileImageURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupName = widget.groupName;
    image = NetworkImage(widget.imageURL);
    getCurrentUser();
    getUsers();
    slideDownController = AnimationController(
      vsync: (this),
      duration: const Duration(milliseconds: 150),
    );
    slideDownController.addListener(() {
      setState(() {});
    });
  }

  void updateGroupName(String name) {
    FirebaseFirestore.instance
        .collection('group_info')
        .doc('2WBJdu9aODNW18MywfU9')
        .update({'name': name});
    groupName = name;
    setState(() {});
  }

  void getCurrentUser() async {
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Hero(
          tag: 'groupInfo',
          child: Text(
            "Group Details",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Hero(
            tag: 'logo',
            child: Image(
              height: 5.0,
              image: AssetImage('images/flash.png'),
            ),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: double.maxFinite,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            border: Border.all(
              color: Colors.black26,
              width: 2.0,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundImage: image,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 24.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          TextEditingController textController =
                              TextEditingController(text: groupName);
                          showDialog(
                              context: context,
                              builder: (context) {
                                String newName = groupName;
                                return AlertDialog(
                                  title: const Text(
                                    "Group Name",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: TextField(
                                    onChanged: (value) {
                                      newName = value;
                                    },
                                    autofocus: true,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      focusColor: Colors.grey.shade200,
                                      contentPadding: const EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.lightBlueAccent,
                                            width: 2.0),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                  actions: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        margin: const EdgeInsets.all(20.0),
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        updateGroupName(newName);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(20.0),
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text("OK"),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!listOpen) {
                      slideDownController.forward();
                    } else {
                      await slideDownController.reverse();
                    }
                    listOpen = !listOpen;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: listOpen
                          ? Colors.lightBlueAccent
                          : Colors.grey.shade300,
                      border: listOpen
                          ? null
                          : Border.all(color: Colors.grey.shade300, width: 2.0),
                      borderRadius: listOpen
                          ? const BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                            )
                          : const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Group Members",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        listOpen
                            ? const Icon(Icons.keyboard_arrow_up_rounded)
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: listOpen,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: userItems,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getUsers() async {
    var users = await _firestore.collection('users').get();
    for (var user in users.docs) {
      userItems.add(
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 2.0),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(
                    userDetails: user,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.data()['profileImageURL']),
              ),
              title: Text(
                user.data()['email'] == _auth.currentUser?.email
                    ? 'you (${user.data()['username']})'
                    : user.data()['username'],
              ),
            ),
          ),
        ),
      );
      setState(() {});
    }
  }
}
