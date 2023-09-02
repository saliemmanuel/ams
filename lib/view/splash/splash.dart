// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:ams/services/services_auth.dart';
import 'package:ams/storage/local_storage/local_storage.dart';
import 'package:ams/view/login/login.dart';
import 'package:ams/view/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/firebase_auth.dart';
import '../widgets/custom_dialogue_card.dart';
import '../../services/service_locator.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    initNextPage();
    super.initState();
  }

  // initialiation de la page suivante
  initNextPage() async {
   
    // Initialisation le temps d'attente à 2s
    Timer(const Duration(seconds: 2), () async {
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
          Get.off(() => LocalStorage.getData(key: 'onboarding') == null
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset("assets/images/logo.png"),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}