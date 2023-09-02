import 'package:ams/models/vendeur_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  saveBoutiqueDatas({var boutiqueModels, String? collection}) async {
    return await locator
        .get<ServiceAuth>()
        .firestore
        .collection(collection!)
        .add(boutiqueModels!.toMap())
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
}
