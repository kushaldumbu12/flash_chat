import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chatwindow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class EditProfile extends StatefulWidget {
  static String path = 'editProfile';
  final bool newUser;
  const EditProfile({super.key, this.newUser = false});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late bool newUser;
  bool showSpinnerScreen = false;
  bool showSpinnerImage = false;
  ImageProvider _image = const AssetImage('images/flash.png');

  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late String? userEmail;
  late int userColor;
  late String userDOB;
  late int userMobileno;
  late String username;

  late String d, m, y;

  late Color selectedColor = const Color(0xFFFFFFFF);

  void redirect() => Navigator.pushNamed(context, ChatWindow.path);

  late String imagePath = 'D:/flash_chat/images/flash.png';

  Uint8List? pickerWeb;
  bool hasImage = false;

  FilePickerResult? pickedFile;

  void getImageFromGallery() async {
    showSpinnerImage;
    setState(() {});
    if (kIsWeb) {
      pickedFile = await FilePicker.platform.pickFiles();
      var selectFile = pickedFile?.files.first.name;
      if (selectFile != null) {
        _image = MemoryImage(pickedFile!.files.first.bytes!);
        hasImage = true;
        showSpinnerImage = false;
        setState(() {});
      }
    } else {
      final picker = ImagePicker();
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      String? path = file?.path;
      imagePath = path!;
      _image = Image.file(File(path)).image;
      hasImage = true;
      showSpinnerImage = false;
      setState(() {});
      showSpinnerImage = false;
    }
  }

  final metadata = SettableMetadata(contentType: 'image_');

  Future<String> uploadImageToStorage() async {
    if (kIsWeb) {
      final storageRef = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putData(pickedFile!.files.first.bytes!, metadata);

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } else {
      final storageRef = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      var imageAdd = await storageRef.putFile(File(imagePath));
      return imageAdd.ref.getDownloadURL();
    }
  }

  void getCurrentUserEmail() {
    userEmail = _auth.currentUser?.email;
    textController = TextEditingController(text: userEmail);
  }

  late List<int> usedColors = [];

  void getUsedColors() async {
    var users = await _store.collection('users').get();
    for (var user in users.docs) {
      int col = user.data()['color'];
      usedColors.add(col);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsedColors();
    getCurrentUserEmail();
    newUser = widget.newUser;
    dFocusNode = FocusNode();
    mFocusNode = FocusNode();
    yFocusNode = FocusNode();
    uFocusNode = FocusNode();
  }

  @override
  void dispose() {
    dFocusNode.dispose();
    mFocusNode.dispose();
    yFocusNode.dispose();
    uFocusNode.dispose();
    dController.dispose();
    mController.dispose();
    yController.dispose();
    super.dispose();
  }

  late TextEditingController textController;
  TextEditingController dController = TextEditingController();
  TextEditingController mController = TextEditingController();
  TextEditingController yController = TextEditingController();

  late FocusNode dFocusNode;
  late FocusNode mFocusNode;
  late FocusNode yFocusNode;
  late FocusNode uFocusNode;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinnerScreen,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              textAlign: TextAlign.center,
              newUser ? "Add Profile" : "Edit Profile",
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ModalProgressHUD(
                  inAsyncCall: showSpinnerImage,
                  child: GestureDetector(
                    onTap: () async {
                      showSpinnerImage = true;
                      setState(() {});
                      getImageFromGallery();
                      showSpinnerImage = false;
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.lightBlue.shade200,
                      backgroundImage: _image,
                      child: Center(
                        child: hasImage
                            ? null
                            : const Text(
                                'Add profile Image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: textController,
                  readOnly: true,
                  decoration: InputDecoration(
                    focusColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  onSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(dFocusNode),
                  onChanged: (value) => username = value,
                  decoration: InputDecoration(
                    focusColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.lightBlueAccent, width: 2.0),
                    ),
                    hintText: 'Enter Username',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Flexible(
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          d = value;
                          if (value.length >= 2) {
                            dFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(mFocusNode);
                          }
                        },
                        textAlign: TextAlign.center,
                        focusNode: dFocusNode,
                        controller: dController,
                        decoration: InputDecoration(
                          focusColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: 'dd',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          m = value;
                          if (value.length >= 2) {
                            mFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(yFocusNode);
                          }
                        },
                        textAlign: TextAlign.center,
                        focusNode: mFocusNode,
                        controller: mController,
                        decoration: InputDecoration(
                          focusColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: 'MM',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          y = value;
                          if (value.length >= 4) {
                            dFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(uFocusNode);
                          }
                        },
                        textAlign: TextAlign.center,
                        focusNode: yFocusNode,
                        controller: yController,
                        decoration: InputDecoration(
                          focusColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: 'yyyy',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  onChanged: (value) => userMobileno = int.parse(value),
                  keyboardType: TextInputType.number,
                  focusNode: uFocusNode,
                  decoration: InputDecoration(
                    focusColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.lightBlueAccent, width: 2.0),
                    ),
                    hintText: 'Enter Mobile Number',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Flexible(
                      child: Text(
                        'Choose message bubble color',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 100.0,
                        width: 250.0,
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xfffffcc8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfffffcc8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xfffffcc8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xfffffcc8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFffe1c8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFffe1c8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFffe1c8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFffe1c8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFffc8e6);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFffc8e6),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFffc8e6).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFffc8e6)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFc8e6ff);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFc8e6ff),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFc8e6ff).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFc8e6ff)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFe7ffc8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFe7ffc8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFe7ffc8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFe7ffc8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFccffc8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFccffc8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFccffc8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFccffc8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFf5c7b8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFf5c7b8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFf5c7b8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFf5c7b8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedColor = const Color(0xFFf9ead8);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFf9ead8),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        border: usedColors.contains(
                                                const Color(0xFFf9ead8).value)
                                            ? Border.all(
                                                color: Colors.grey, width: 4.0)
                                            : (selectedColor.value ==
                                                    0xFFf9ead8)
                                                ? Border.all(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    width: 2.0)
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    showSpinnerScreen = true;
                    userDOB = '$d-$m-$y';
                    setState(() {});
                    userColor = selectedColor.value;
                    String url = await uploadImageToStorage();
                    Map<String, dynamic> data = {
                      'color': userColor,
                      'dob': userDOB,
                      'email': userEmail!,
                      'mobileno': userMobileno,
                      'profileImageURL': url,
                      'username': username
                    };
                    _store.collection('users').add(data);
                    showSpinnerScreen = false;
                    setState(() {});
                    redirect();
                  },
                  child: Container(
                    width: 200.0,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'SAVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
