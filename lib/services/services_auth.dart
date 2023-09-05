// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import '../auth/firebase_auth.dart';
import '../models/user.dart';
import '../provider/home_provider.dart';
import '../view/admin/home/admin_home.dart';
import '../view/vendeur_home/vendeur_home.dart';
import 'service_locator.dart';
import '../view/widgets/custom_dialogue_card.dart';

class ServiceAuth {
  final _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firestore;
  final _emailMaskRegExp = RegExp('^(.)(.*?)([^@]?)(?=@[^@]+\$)');
  String maskEmail(String input, [int minFill = 3, String fillChar = '*']) {
    return input.replaceFirstMapped(_emailMaskRegExp, (m) {
      var start = m.group(1);
      var middle = fillChar * max(minFill, m.group(2)!.length);
      var end = m.groupCount >= 3 ? m.group(3) : start;
      return "$start$middle$end";
    });
  }

  connexion({String? email, String? pass, BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle("Connexion", context!);
      await locator
          .get<FirebasesAuth>()
          .sigInWithEmail(email: email, password: pass);
      Stream<User?> response = locator.get<FirebasesAuth>().authStateChanges;
      var isConnected = await response.any((element) => element!.email != null);
      if (isConnected) {
        dynamic docs = await locator
            .get<FirebasesAuth>()
            .getUserData(id: locator.get<FirebasesAuth>().curentUser!.uid);
        Map<String, dynamic>? data = docs?.data();
        // je verifie si l'utilisateur est déjà enregistré dans la bd
        redirectionUtil(context: context, data: data);
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.message!);
    }
  }

  inscription(
      {Users? user, String? email, String? pass, BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle("Inscription...", context!);
      await locator
          .get<FirebasesAuth>()
          .createUserWithEmail(email: email, password: pass);
      Stream<User?> response = locator.get<FirebasesAuth>().authStateChanges;
      var isConnected = await response.any((element) => element!.email != null);
      if (isConnected) {
        Get.back();
        locator
            .get<FirebasesAuth>()
            .restaurePasswordByEmail(email: email)
            .then((value) {
          succesTransaction(
                  "Un e-mail a été envoyer au ${locator.get<ServiceAuth>().maskEmail(email!)}",
                  context)
              .then((value) {
            var userUi = Users(
                createAt: DateTime.now().toIso8601String(),
                status: user!.status,
                email: user.email,
                grade: user.grade,
                messagingToken: user.messagingToken,
                nom: user.nom,
                prenom: user.prenom,
                telephone: user.telephone,
                id: locator.get<FirebasesAuth>().curentUser!.uid);
            saveUserDataCollections(context: context, user: userUi);
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.message!);
    }
  }

  inscriptionVendeur(
      {required Vendeur? vendeur,
      String? pass,
      BoutiqueModels? boutiqueModels,
      BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle(
          "Création de la Boutique et inscription du vendeur...", context!);
      await locator
          .get<FirebasesAuth>()
          .createVendeurWithEmail(email: vendeur!.email, password: pass)
          .then((val) {
        Get.back();
        // Création du vendeur
        var vendeurs = Vendeur(
          createAt: DateTime.now().toIso8601String(),
          idAdmin: vendeur.idAdmin,
          id: val.user!.uid,
          status: vendeur.status,
          email: vendeur.email,
          grade: vendeur.grade,
          messagingToken: vendeur.messagingToken,
          nom: vendeur.nom,
          prenom: vendeur.prenom,
          telephone: vendeur.telephone,
        );

        // Créatioin de la boutique
        var boutique = BoutiqueModels(
            id: boutiqueModels!.id,
            vendeur: [vendeurs.id!],
            dateCreation: DateTime.now().toIso8601String(),
            nomBoutique: boutiqueModels.nomBoutique,
            idAdmin: boutiqueModels.idAdmin,
            quartierBoutique: boutiqueModels.quartierBoutique,
            villeBoutique: boutiqueModels.villeBoutique);
        // Save vendeur
        saveVendeurData(vendeurs: vendeurs, context: context);
        // Save boutique
        saveBoutiqueDataCollections(context: context, boutiqueModels: boutique);
        // Send password e-mail link
        locator
            .get<FirebasesAuth>()
            .resetPasswordVendeurByEmail(email: vendeurs.email)
            .then((values) {
          //
          succesTransaction(
                  "Un e-mail a été envoyer au ${locator.get<ServiceAuth>().maskEmail(vendeurs.email!)}",
                  context)
              .then((value) {
            Get.back();
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.message!);
    }
  }

  saveBoutiqueDataCollections(
      {BoutiqueModels? boutiqueModels, BuildContext? context}) async {
    try {
      await locator.get<FirebasesAuth>().saveBoutiqueDatas(
          boutiqueModels: boutiqueModels!, collection: 'boutique');
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  saveVendeurData({Vendeur? vendeurs, BuildContext? context}) async {
    try {
      await locator
          .get<FirebasesAuth>()
          .saveVendeurDatas(vendeur: vendeurs, collection: 'users');
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  saveArticleData({ArticleModels? article, BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .saveArticleDatas(article: article)
          .then((value) {
        Get.back();
        dialogueAndonTapDismiss(
            onTapDismiss: () {
              Get.back();
              Get.back();
              Provider.of<HomeProvider>(context, listen: false)
                  .setNombreBoutique(article!.idBoutique);
            },
            panaraDialogType: PanaraDialogType.success,
            context: context,
            title: "Succès",
            message: "L'article a été ajouter avec succès");
      });
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  editStock({
    ArticleModels? article,
    BuildContext? context,
    String? key,
    dynamic value,
  }) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .updateArticleDatas(article: article, key: key, value: value)
          .then((value) {
        Get.back();
        dialogueAndonTapDismiss(
            onTapDismiss: () {
              Get.back();
              Get.back();
            },
            panaraDialogType: PanaraDialogType.success,
            context: context,
            title: "Succès",
            message: "L'article a été modifier avec succès");
      });
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  addNewVendeurDataInBoutiques(
      {Vendeur? vendeur,
      BoutiqueModels? boutiqueModels,
      BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle(
          "Inscription du nouveau vendeur...", context!);
      await locator
          .get<FirebasesAuth>()
          .createVendeurWithEmail(
              email: vendeur!.email, password: "grade.trim()1234")
          .then((val) {
        Get.back();

        // Création du vendeur
        var vendeurs = Vendeur(
          createAt: DateTime.now().toIso8601String(),
          idAdmin: vendeur.idAdmin,
          id: val.user!.uid,
          status: vendeur.status,
          email: vendeur.email,
          grade: vendeur.grade,
          messagingToken: vendeur.messagingToken,
          nom: vendeur.nom,
          prenom: vendeur.prenom,
          telephone: vendeur.telephone,
        );
        // Update vendeur
        saveVendeurData(context: context, vendeurs: vendeurs);
        updateVendeurlistDatas(
            vendeurs: vendeurs,
            boutiqueModels: boutiqueModels,
            context: context);
        // Send reset password e-mail link
        locator
            .get<FirebasesAuth>()
            .resetPasswordVendeurByEmail(email: vendeurs.email)
            .then((values) {
          //
          succesTransaction(
                  "Un e-mail a été envoyer au ${locator.get<ServiceAuth>().maskEmail(vendeurs.email!)}",
                  context)
              .then((value) {
            Get.back();
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.message!);
    }
  }

  updateVendeurlistDatas(
      {Vendeur? vendeurs,
      required BoutiqueModels? boutiqueModels,
      BuildContext? context}) async {
    try {
      await locator.get<FirebasesAuth>().updateListVendeurBoutiques(
          vendeur: vendeurs!.id!,
          boutiqueModels: boutiqueModels,
          collection: 'boutique');
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  saveUserDataCollections({Users? user, BuildContext? context}) async {
    try {
      var response = await locator
          .get<FirebasesAuth>()
          .saveUserDatas(user: user, collection: 'users');
      if (response) {
        Get.back();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteVendeur({String? vendeurId, var context}) {
    simpleDialogueCardSansTitle("Suppréssion...", context!);
    locator
        .get<FirebasesAuth>()
        .removeVendeurBoutique(vendeurId: vendeurId)
        .then((value) {
      Get.back();
    });
  }

  updateMessagingToken(
      {Users? user, BuildContext? context, required String? mes}) async {
    try {
      await locator
          .get<FirebasesAuth>()
          .updateUserMessagingToken(user: user, collection: 'users');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  sendEmailVerification({Users? user, BuildContext? context, String? email}) {
    locator
        .get<FirebasesAuth>()
        .curentUser!
        .sendEmailVerification()
        .whenComplete(
      () {
        saveUserDataCollections(context: context, user: user);
        dialogue(
            panaraDialogType: PanaraDialogType.success,
            message: "Compte créer avec succès",
            title: "",
            context: context);
      },
    );
  }

  redirectionUtil({var data, BuildContext? context}) {
    if (data != null) {
      var user = Users.fromMap(data);
      // je verifie si l'utilisateur à déjà un token pour les messages
      // Si c'est vide
      if (user.messagingToken == "vide") {
        // je lui créer un teken
        user.messagingsToken = locator.get<HomeProvider>().messagingToken;
        // Je modifie le token dans la bd
        locator
            .get<ServiceAuth>()
            .updateMessagingToken(context: context, user: user, mes: "Vide");
      } else
      // Si le token dans la bd n'est pas vide mais qu'il est different
      // en cas de changement de téléphone
      if (user.messagingToken != locator.get<HomeProvider>().messagingToken) {
        // je modifie avec le nouveau token
        user.messagingsToken = locator.get<HomeProvider>().messagingToken;
        locator.get<ServiceAuth>().updateMessagingToken(
            context: context, user: user, mes: "Changement de token");
      }
      // Je charge le compte d'utilisateur dans la variable globale
      locator.get<HomeProvider>().setUserData(user);
      // je fait les redirection
      if (data['grade'] == 'admin') {
        // Compte admin
        Get.offAll(() => AdminHome(users: user));
      } else {
        // Compte vendeur
        Get.offAll(() => VendeurHome(users: user));
      }
    }
  }
}
