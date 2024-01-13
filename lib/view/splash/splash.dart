// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:ams/services/services_auth.dart';
import 'package:ams/storage/local_storage/local_storage.dart';
import 'package:ams/view/login/login.dart';
import 'package:ams/view/onboarding/onboarding.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../auth/firebase_auth.dart';
import '../../messaging/messaging.dart';
import '../widgets/custom_dialogue_card.dart';
import '../../services/service_locator.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription? subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    if (kIsWeb) {
      initNextPage();
    } else {
      checkConnexoion();
    }
    super.initState();
  }

  checkConnexoion() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      subscription = InternetConnectionChecker().onStatusChange.listen((event) {
        isDeviceConnected = event == InternetConnectionStatus.connected;
        if (isDeviceConnected) {
          init();
          initNextPage();
        } else {
          showDialogBox();
        }
      });
    });
  }

  init() async {
    try {
      await FirebaseMessaging.instance.getInitialMessage();
      await FireMessageging().getTokenDeviceToken();
      // await FireMessageging.initializeLocalNotifications();
      // FireMessageging().onMessageListen();
      FireMessageging().requestPermission();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // initialiation de la page suivante
  initNextPage() async {
    // Initialisation le temps d'attente à 2s
    Timer(const Duration(seconds: 1), () async {
      try {
        // je verifie si l'user est authentifier
        if (locator.get<FirebasesAuth>().curentUser != null) {
          // je recupère ses informations de la bd a partir de son uid
          dynamic docs = await locator
              .get<FirebasesAuth>()
              .getUserData(id: locator.get<FirebasesAuth>().curentUser!.uid);
          Map<String, dynamic>? data = docs?.data();
          // je verifie si l'utilisateur est déjà enregistré dans la bd
          locator
              .get<ServiceAuth>()
              .redirectionUtil(context: context, data: data);
        } else {
          Get.off(() => LocalStorage().getData(key: 'onboarding') == null
              ? const Onboarding()
              : const Login());
        }
      } on FirebaseAuthException catch (e) {
        errorDialogueCard("Erreur", e.message!, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Image.asset("assets/images/logo.png", height: 230.0, width: 650),
            const Spacer(flex: 2),
            const CircularProgressIndicator(),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  showDialogBox() => dialogueAndonTapDismiss(
        panaraDialogType: PanaraDialogType.warning,
        context: context,
        title: "Pas de connection",
        message: "Veuillez vérifier votre connectivité Internet",
        onTapDismiss: () {
          Get.back();
          checkConnexoion();
        },
      );
}
