// ignore_for_file: use_build_context_synchronously

import 'dart:collection';
import 'dart:math';

import 'package:ams/models/article_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:ams/view/admin/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import '../auth/firebase_auth.dart';
import '../models/facture_client_model.dart';
import '../models/user.dart';
import '../provider/home_provider.dart';
import '../view/vendeur/vendeur.dart';
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

  // transfert des articles dans une autre boutique

  saveArticleDataMultiple(
      {HashSet<ArticleModels>? multipleSelection,
      required String newIdBoutique,
      BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      int currentIndex = 0;

      for (var element in multipleSelection!) {
        var codeEnregistrement = "Produit${Random().nextInt(15500)}";

        currentIndex++;
        ArticleModels? article = ArticleModels(
          codeEnregistrement: element.codeEnregistrement,
          createAt: DateTime.now().toIso8601String(),
          designation: element.designation,
          id: "${locator.get<HomeProvider>().user.id}$codeEnregistrement",
          idAdmin: element.idAdmin,
          idBoutique: newIdBoutique,
          nomBoutique: element.nomBoutique,
          prixAchat: element.prixAchat,
          prixVente: element.prixVente,
          stockActuel: element.stockActuel,
          stockCritique: element.stockCritique,
          stockNormal: element.stockNormal,
          prixNonAuto: element.prixNonAuto,
        );
        locator.get<FirebasesAuth>().saveArticleDatas(article: article);

        if (currentIndex == multipleSelection.length) {
          Get.back();
          dialogueAndonTapDismiss(
              onTapDismiss: () {
                Get.back();
                Provider.of<HomeProvider>(context, listen: false)
                    .setNombreBoutique(article.idBoutique);
                Provider.of<HomeProvider>(context, listen: false)
                    .clearMultipleSelection();
                Get.back();
              },
              panaraDialogType: PanaraDialogType.success,
              context: context,
              title: "Transfère",
              message: "Article(s) transféré avec succès.");
        }
      }
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur",
          message: e.toString());
    }
  }

  // enregistre la facture du client
  saveFactureClientData(
      {required List<FactureClient>? facture,
      required String nom,
      required String telephone,
      required String idBoutique,
      required double? netPayer,
      required Vendeur? vendeur,
      BuildContext? context}) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .saveFactureClientDatas(
              vendeur: vendeur,
              facture: facture,
              nom: nom,
              idBoutique: idBoutique,
              telephone: telephone,
              netPayer: netPayer)
          .then((value) {
        Get.back();
        dialogueAndonTapDismiss(
            onTapDismiss: () {
              Get.back();
              Get.back();
              Provider.of<HomeProvider>(context, listen: false)
                  .remoceAllValeurArticleVente();
            },
            panaraDialogType: PanaraDialogType.success,
            context: context,
            title: "Succès",
            message: "Facture enregistré avec succès");
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

  editUsersNomAndPrenom({
    Users? users,
    BuildContext? context,
    String? nom,
    String? prenom,
  }) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .updateUserDatas(users: users, nom: nom, prenom: prenom)
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
            message: "Modification éffectuée");
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

  getCreateUserCode({
    Users? users,
    BuildContext? context,
    String? code,
  }) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .createUserCode(users: users, code: code)
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
            message: "Effectuée");
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

  ///
  getUpdateUserCode({
    Users? users,
    BuildContext? context,
    String? code,
  }) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .updateUserCode(users: users, code: code)
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
            message: "Effectuée");
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

  getVerifUserCode(
      {Users? users,
      BuildContext? context,
      String? code,
      required Function(bool) callBack}) async {
    try {
      simpleDialogueCardSansTitle("Traitement...", context!);
      await locator
          .get<FirebasesAuth>()
          .verifUserCode(users: users, code: code, callBack: callBack);
    } catch (e) {
      Get.back();
      dialogue(
          panaraDialogType: PanaraDialogType.error,
          context: context,
          title: "Erreur aaa",
          message: e.toString());
    }
  }

  editNomBoutique({
    BoutiqueModels? boutiqueModels,
    BuildContext? context,
    String? nouveauNom,
  }) async {
    try {
      simpleDialogueCardSansTitle("Enregistrement...", context!);
      await locator
          .get<FirebasesAuth>()
          .updateNomBoutiqueDatas(
              nouveauNom: nouveauNom, boutiqueModels: boutiqueModels)
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
            message: "Modification éffectuée");
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

  deleteArticle({String? idArticle, var context}) {
    Get.back();
    simpleDialogueCardSansTitle("Suppréssion...", context!);
    locator
        .get<FirebasesAuth>()
        .removeArticleBoutique(idArticle: idArticle)
        .then((value) {
      Get.back();
    });
  }

  deleteMultipleArticle(
      {HashSet<ArticleModels>? multipleSelection, var context}) {
    Get.back();
    int currentIndex = 0;
    simpleDialogueCardSansTitle("Suppréssion...", context!);
    for (var element in multipleSelection!) {
      currentIndex++;
      locator
          .get<FirebasesAuth>()
          .removeSingleArticleBoutiqueAction(idArticle: element.id);
      if (currentIndex == multipleSelection.length) {
        Get.back();
        dialogueAndonTapDismiss(
            onTapDismiss: () {
              Get.back();
              Provider.of<HomeProvider>(context, listen: false)
                  .clearMultipleSelection();
            },
            panaraDialogType: PanaraDialogType.success,
            context: context,
            title: "Suppréssion",
            message: "Article(s) supprimé avec succès.");
      }
    }
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

  redirectionUtil({var data, BuildContext? context}) async {
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
        Get.offAll(() => Admin(users: user));
      } else {
        // Compte vendeur
        // je recupère la boutique du vendeur
        var docs = await locator
            .get<FirebasesAuth>()
            .getBoutiqueVendeurData(id: user.id);
        var boutique = BoutiqueModels.fromMap(docs);
        Get.offAll(() => VendeursH(users: user, boutique: boutique));
      }
    }
  }

  showToast(String msg,
      {int? duration, required BuildContext? context, int? position}) {
    FlutterToastr.show(msg, context!, duration: duration, position: position);
  }

  restaurePasswordByEmail(
      {String? email, required BuildContext context}) async {
    try {
      simpleDialogueCardSansTitle("Traitement...", context);
      await locator
          .get<FirebasesAuth>()
          .sendPasswordResetEmail(email: email!.trim())
          .whenComplete(() {
        Navigator.pop(context);
        succesTransaction(
                "Un e-mail recupération a été envoyer au ${maskEmail(email)}",
                context)
            .then((value) => Get.back());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
