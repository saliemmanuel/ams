import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../provider/home_provider.dart';
import '../services/service_locator.dart';
import '../themes/theme.dart';

Future<void> backgroundMessagingHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class FireMessageging {
  // création des instances 
  var messaging = FirebaseMessaging.instance;
  static ReceivedAction? initialAction;

  // Mehtode pour la récupération du token permettant l'envoi des message
  getTokenDeviceToken() async {
    // les permissions
    await messaging.requestPermission();
    // acces au token
    await messaging.getToken().then((token) async {
      if (token != null) {
        // ici uplader le Token de l'utilisateur pour un éventuelle utilisation
        debugPrint('Push Token: $token');
        locator.get<HomeProvider>().messagingToken = token;
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessagingHandler);
  }


  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'AMS',
              channelName: 'AMS',
              channelDescription: 'Notification AMS',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              ledColor: Palette.primary,
              channelShowBadge: true,
              criticalAlerts: true,
              defaultColor: Palette.primary)
        ],
        debug: false);
  }

  requestPermission() async {
    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }

  onMessageListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        localNotifications(
            chanelId: Random().nextInt(10).toString(),
            body: message.notification?.body);
      }
    });
  }

  static localNotifications({String? body, required String? chanelId}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            criticalAlert: true,
            category: NotificationCategory.Status,
            id: int.parse(chanelId!),
            channelKey: 'AMS',
            title: 'AMS',
            body: body));
  }

  Future<void> sendPushNotification(var tokenRecipient) async {
    String authorization = dotenv.get('KEY_MESSAGING');

    try {
      await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'key=$authorization'
          },
          body: jsonEncode({
            "to": "$tokenRecipient",
            "notification": {
              "title": "Djanguirde",
              "body": "Bonjours c'est l'application Djanguirde,,,,",
              "data": {"go_route": "/home"}
            }
          }));
    } catch (e) {
      debugPrint('\nsendPushNotificationE: $e');
    }
  }
}
