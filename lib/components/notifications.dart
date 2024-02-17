import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/chatwindow.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static GlobalKey<NavigatorState> navigatorKey = MyApp().navigatorKey;
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      'flash',
      [
        NotificationChannel(
          channelKey: 'FlashNotification',
          channelName: 'FlashNotification',
          channelDescription: 'FlashDescription',
          defaultColor: Colors.lightBlueAccent,
          playSound: true,
        ),
      ],
      debug: true,
    );
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationReceived,
      onDismissActionReceivedMethod: onNotificationDismissed,
      onNotificationCreatedMethod: onNotificationCreated,
      onNotificationDisplayedMethod: onNotificationDisplay,
    );
  }

  static Future<void> onNotificationCreated(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onNotificationReceived(
      ReceivedNotification receivedNotification) async {
    final payload = receivedNotification.payload ?? {};
    if (payload['navigate'] == "true") {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
          ChatWindow.path, ModalRoute.withName(ChatWindow.path));
    }
  }

  static Future<void> onNotificationDisplay(
      ReceivedNotification receivedNotification) async {
    //assert(receivedNotification || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'FlashNotification',
        title: receivedNotification.title,
        body: receivedNotification.body,
        summary: receivedNotification.summary,
        payload: receivedNotification.payload,
        actionType: receivedNotification.actionType!,
        notificationLayout: NotificationLayout.Default,
        category: receivedNotification.category,
        bigPicture: receivedNotification.bigPicture,
      ),
    );
  }

  static Future<void> onNotificationDismissed(
      ReceivedNotification receivedNotification) async {}
}
