import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash_chat/screens/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/chatwindow.dart';
import 'screens/edit_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void saveToken(String token) async {
  var firestore = FirebaseFirestore.instance;
  var deviceId = await _getId();
  await firestore.collection('tokens').doc(deviceId).set({
    'token': token,
  });
}

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (TargetPlatform.iOS == defaultTargetPlatform) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (TargetPlatform.iOS == defaultTargetPlatform) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  fcmInitialize();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MyApp());
}

void fcmInitialize() async {
  var fcm = FirebaseMessaging.instance;
  await fcm.getToken().then((token) {
    saveToken(token!);
    print(' app token : $token');
  });
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print('Notification title : ${message.notification!.title}');
  print('Notification body : ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      initialRoute: LoadingScreen.path,
      routes: {
        LoadingScreen.path: (context) => const LoadingScreen(),
        Welcome.path: (context) => const Welcome(),
        Login.path: (context) => const Login(),
        SignUp.path: (context) => const SignUp(),
        ChatWindow.path: (context) => const ChatWindow(),
        EditProfile.path: (context) => const EditProfile(
              newUser: true,
            )
      },
    );
  }
}
