import 'package:flash_chat/screens/image_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> userDetails;
  const UserProfile({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment
                .bottomCenter, // Change this to create a vertical gradient
            colors: [
              Color.fromRGBO(
                  214, 241, 242, 1), // Equivalent to hsla(186, 33%, 94%, 1)
              Color.fromRGBO(
                  181, 198, 224, 1), // Equivalent to hsla(216, 41%, 79%, 1)
            ],
          ),
        ),
        child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 2.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageFullScreen(
                              image: NetworkImage(
                                  userDetails.data()['profileImageURL']),
                            )),
                  );
                },
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundImage:
                      NetworkImage(userDetails.data()['profileImageURL']),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 2.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 2.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Username"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(userDetails.data()['username']),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 2.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Date of Birth"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(userDetails.data()['dob']),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 2.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Mobile Number"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(userDetails.data()['mobileno'].toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Email ID"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(userDetails.data()['email']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
