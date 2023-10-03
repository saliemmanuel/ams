import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/facture_client_model.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/login/login.dart';
import 'package:ams/view/widgets/formate_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/service_locator.dart';
import '../services/services_auth.dart';

class FirebasesAuth {
  final _firebaseAuth = FirebaseAuth.instance;
  User? get curentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  FirebaseAuth get firebaseAuthInstance => _firebaseAuth;

  sigInWithEmail({String? email, String? password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }

  Future<UserCredential> createUserWithEmail(
      {String? email, String? password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }

  Future<UserCredential> createVendeurWithEmail(
      {String? email, String? password}) async {
    FirebaseApp sencondinst = await Firebase.initializeApp(
      name: 'sencondinst',
      options: Firebase.app().options,
    );
    var vendeurIntance = FirebaseAuth.instanceFor(app: sencondinst);
    return vendeurIntance.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }

  resetPasswordVendeurByEmail({String? email}) async {
    FirebaseApp sencondinst = await Firebase.initializeApp(
      name: 'sencondinst',
      options: Firebase.app().options,
    );
    var vendeurIntance = FirebaseAuth.instanceFor(app: sencondinst);
    try {
      return vendeurIntance.sendPasswordResetEmail(email: email!.trim());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  restaurePasswordByEmail({String? email}) {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email!.trim());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  signOut() async {
    await _firebaseAuth.signOut();
    Get.offAll(() => const Login());
  }

  saveUserDatas({Users? user, String? collection}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection(collection!)
        .doc(user!.id)
        .set(user.toMap())
        .then((value) => value);
  }

  saveVendeurDatas({Vendeur? vendeur, String? collection}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection(collection!)
        .doc(vendeur!.id)
        .set(vendeur.toMap())
        .then((value) => value);
  }

  saveArticleDatas({ArticleModels? article}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("article")
        .doc(article!.id)
        .set(article.toMap());
  }

  saveFactureClientDatas(
      {required List<FactureClient>? facture,
      required String nom,
      required String telephone,
      required String idBoutique,
      required Vendeur? vendeur,
      required double? netPayer}) async {
    int nouvelStock = 0;
    for (var e in facture!) {
      nouvelStock = e.articleModels!.stockActuel! - e.quantite!;
      updateArticleDatas(
        article: e.articleModels,
        key: "stockActuel",
        value: nouvelStock,
      );
    }

    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("facture")
        .add({
      "facture": facture.map((e) => e.toMap()),
      'nom': nom,
      "telephone": telephone,
      "netPayer": netPayer,
      "idBoutique": idBoutique,
      "vendeur": vendeur!.toMap(),
      "createAt": formatDate(date: DateTime.now().toString())
    });
  }

  updateArticleDatas({ArticleModels? article, String? key, value}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("article")
        .doc(article!.id)
        .update({key!: value!});
  }

  updateUserDatas(
      {Users? users, required String? nom, required String? prenom}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("users")
        .doc(users!.id)
        .update({"nom": nom, "prenom": prenom});
  }

  createUserCode({Users? users, required String? code}) async {
    var hashCode = locator
        .get<HomeProvider>()
        .chiffrement(payload: {"users": users!.toMap(), "code": code});
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("code")
        .doc(users.id)
        .set({'id': users.id, "users": users.toMap(), "code": hashCode});
  }

  updateUserCode({Users? users, required String? code}) async {
    var hashCode = locator
        .get<HomeProvider>()
        .chiffrement(payload: {"users": users!.toMap(), "code": code});
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("code")
        .doc(users.id)
        .set({'id': users.id, "users": users.toMap(), "code": hashCode});
  }

  verifUserCode(
      {Users? users,
      required String? code,
      required Function(bool) callBack}) async {
    DocumentSnapshot<Map<String, dynamic>> data = await locator
        .get<ServiceAuth>()
        .firestore
        .collection("code")
        .doc(users!.id)
        .get();
    if (data.data()!.isNotEmpty) {
      Get.back();
    }
    await callBack(locator
            .get<HomeProvider>()
            .deChiffrement(token: data.data()!['code'])['code'] ==
        code);
  }

  updateNomBoutiqueDatas({
    BoutiqueModels? boutiqueModels,
    required String? nouveauNom,
  }) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection("boutique")
        .doc(boutiqueModels!.id)
        .update({"nomBoutique": nouveauNom});
  }

  saveBoutiqueDatas(
      {BoutiqueModels? boutiqueModels, String? collection}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection(collection!)
        .doc(boutiqueModels!.id)
        .set(boutiqueModels.toMap())
        .then((value) => value);
  }

  updateUserMessagingToken({Users? user, String? collection}) async {
    await locator
        .get<ServiceAuth>()
        .firestore
        .collection(collection!)
        .doc(user!.id)
        .update({"messagingToken": user.messagingToken}).whenComplete(
            () => true);
  }

  deleteUserAccount() async {
    try {
      _firebaseAuth.currentUser?.providerData.first;
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getUserData({var id}) async {
    try {
      var collection = locator.get<ServiceAuth>().firestore.collection('users');
      var docSnapshot = await collection.doc(id).get();
      if (docSnapshot.exists) {
        return docSnapshot;
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  getBoutiqueVendeurData({var id}) async {
    try {
      var collection =
          locator.get<ServiceAuth>().firestore.collection('boutique');
      var docSnapshot =
          await collection.where("vendeur", arrayContains: id).get();
      if (docSnapshot.docs.isNotEmpty) {
        return docSnapshot.docs[0].data();
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  updateListVendeurBoutiques(
      {String? vendeur,
      BoutiqueModels? boutiqueModels,
      String? collection}) async {
    boutiqueModels!.addVendeur(vendeur!);

    try {
      return await locator
          .get<ServiceAuth>()
          .firestore
          .collection(collection!)
          .doc(boutiqueModels.id)
          .update(boutiqueModels.toMap())
          .then((value) => value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  removeVendeurBoutique({String? vendeurId}) async {
    locator.get<HomeProvider>().boutiqueModels.removeVendeur(vendeurId!);
    try {
      return await locator
          .get<ServiceAuth>()
          .firestore
          .collection("boutique")
          .doc(locator.get<HomeProvider>().boutiqueModels.id)
          .update(locator.get<HomeProvider>().boutiqueModels.toMap())
          .whenComplete(() async => await locator
              .get<ServiceAuth>()
              .firestore
              .collection("users")
              .doc(vendeurId)
              .delete());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  sendPasswordResetEmail({String? email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email!.trim());
  }
}
