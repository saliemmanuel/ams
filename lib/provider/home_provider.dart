import 'package:ams/auth/firebase_auth.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/services_auth.dart';

class HomeProvider extends ChangeNotifier {
  Users? _user;
  BoutiqueModels? _boutiqueModels;

  String messagingToken = '';
  int? _topIndex = 0;
  int? _nomProduit = 0;
  double _valeurStock = 0;

  Users get user => _user!;
  BoutiqueModels get boutiqueModels => _boutiqueModels!;
  int? get nomProduit => _nomProduit!;
  double? get valeurStock => _valeurStock;

  setUserData(Users? user) {
    _user = Users.fromMap(user!.toMap());
    notifyListeners();
  }

  set setBoutiqueModels(BoutiqueModels boutique) {
    _boutiqueModels = boutique;
    notifyListeners();
  }

  setNombreBoutique(String? idBoutique) async {
    var myRef = locator
        .get<ServiceAuth>()
        .firestore
        .collection('article')
        .where("idBoutique", isEqualTo: idBoutique);
    var snapshot = await myRef.count().get();
    _nomProduit = snapshot.count;

    notifyListeners();
  }

  int? get topIndex => _topIndex;
  set setTopIndex(int? value) {
    _topIndex = value;
  }

  destroyUser() async {
    _user = Users(
        createAt: "",
        messagingToken: '',
        id: '',
        nom: '',
        prenom: '',
        telephone: '',
        email: '',
        grade: "",
        status: "");
    notifyListeners();
    locator.get<FirebasesAuth>().signOut();
  }
}
