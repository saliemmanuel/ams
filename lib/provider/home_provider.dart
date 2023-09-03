import 'package:ams/auth/firebase_auth.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class HomeProvider extends ChangeNotifier {
  Users? _user;
  BoutiqueModels? _boutiqueModels;

  String messagingToken = '';
  int? _topIndex = 0;

  Users get user => _user!;
  BoutiqueModels get boutiqueModels => _boutiqueModels!;

  setUserData(Users? user) {
    _user = Users.fromMap(user!.toMap());
    notifyListeners();
  }

  set setBoutiqueModels(BoutiqueModels boutique) {
    _boutiqueModels = boutique;
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
