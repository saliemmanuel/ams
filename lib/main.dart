import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/storage/local_storage/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'messaging/messaging.dart';
import 'themes/theme.dart';
import 'view/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalStorage.init();
  ServiceLocator.initServiceLocator();
  await dotenv.load(fileName: ".env");
  await FirebaseMessaging.instance.getInitialMessage();
  await FireMessageging().getTokenDeviceToken();
  await FireMessageging.initializeLocalNotifications();
  FireMessageging().onMessageListen();
  FireMessageging().requestPermission();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HomeProvider())],
      child: GetMaterialApp(
        title: "AMS",
          debugShowCheckedModeBanner: false,
          theme: ThemeApp.lightTheme(),
          home: const Splash())));
}
