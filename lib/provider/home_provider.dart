import 'package:ams/auth/firebase_auth.dart';
import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/services/service_locator.dart';
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
  double _prixTotal = 0.0;
  List<ArticleModels>? _listArticleVente = [];

  Users get user => _user!;
  BoutiqueModels get boutiqueModels => _boutiqueModels!;
  int? get nomProduit => _nomProduit!;
  double get prixTotal => _prixTotal;
  double? get valeurStock => _valeurStock;
  List<ArticleModels>? get listArticleVente => _listArticleVente;

  setUserData(Users? user) {
    _user = Users.fromMap(user!.toMap());
    notifyListeners();
  }

  calculPrixTotal(double value) {
    _prixTotal += value;
    print(_prixTotal);
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

  setValeurStockBoutique(double? value) async {
    _valeurStock += value!;
  }

  setValeurStockBoutique2(double? value) async {
    _valeurStock = value!;
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
