import 'dart:collection';

import 'package:ams/auth/firebase_auth.dart';
import 'package:ams/models/article_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/facture_client_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/user.dart';
import '../services/services_auth.dart';

class HomeProvider extends ChangeNotifier {
  Users? _user;
  BoutiqueModels? _boutiqueModels;

  String messagingToken = '';
  int? _topIndex = 0;
  int? _nomProduit = 0;
  double _valeurStock = 0;
  final double _prixTotal = 0.0;
  final List<ArticleModels> _listArticleVente = [];
  List<FactureClient> echoVal = [];
  bool _activePaiement = true;

  Users get user => _user!;
  BoutiqueModels get boutiqueModels => _boutiqueModels!;
  int? get nomProduit => _nomProduit!;
  double get prixTotal => _prixTotal;
  double? get valeurStock => _valeurStock;
  List<ArticleModels>? get listArticleVente => _listArticleVente;
  bool get activePaiement => _activePaiement;

  setUserData(Users? user) {
    _user = Users.fromMap(user!.toMap());
    notifyListeners();
  }

  setactivePaiement(bool activePaiement) {
    _activePaiement = activePaiement;
    notifyListeners();
  }

  setEchoVal(FactureClient map) {
    echoVal.add(map);
    notifyListeners();
  }

  set setBoutiqueModels(BoutiqueModels boutique) {
    _boutiqueModels = boutique;
    notifyListeners();
  }

  setNombreBoutique(String? idBoutique) async {
    try {
      var myRef = locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: idBoutique);
      var snapshot = await myRef.count().get();
      _nomProduit = snapshot.count;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setValeurStockBoutique(double? value) async {
    _valeurStock += value!;
  }

  setValeurStockBoutique2(double? value) async {
    _valeurStock = value!;
  }

  setValeurListArticleVente(ArticleModels? value) {
    _listArticleVente.add(value!);
    notifyListeners();
  }

  remoceValeurArticleVente(ArticleModels? value) {
    _listArticleVente.remove(value!);
    notifyListeners();
  }

  remoceAllValeurArticleVente() {
    _listArticleVente.clear();
    echoVal.clear();
    notifyListeners();
  }

  removeWhereListArticleVente(bool Function(FactureClient) test) {
    echoVal.removeWhere(test);
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

  formatDate({String? date}) {
    return DateFormatter.formatStringDate(
      date: date!,
      inputFormat: 'yyyy-MM-dd HH:mm:ss',
      outputFormat: 'dd MMM yyyy à HH:mm:ss',
    );
  }

  // recupération de la clé de chiffrement utilisé
  chiffrement({required Map<String, dynamic> payload}) {
    final String? jwtkey = dotenv.env['JWT_KEY'];
    // instance JWT
    final jwt = JWT(payload);
    // chiffrement du message et creation du token (le chiffré)
    String token = jwt.sign(SecretKey(jwtkey!));
    // renvoi du chiffré
    return token;
  }

  deChiffrement({String? token}) {
    final String? jwtkey = dotenv.env['JWT_KEY'];
    try {
      // Verifition du token (qui as été utiliser lors du chiffrement)
      final jwt = JWT.verify(token!, SecretKey(jwtkey!));
      // renvoi des info claire déchéffré
      return jwt.payload;
    } on JWTExpiredException {
      debugPrint('jwt expired');
    } on JWTException catch (ex) {
      debugPrint(ex.message);
    }
  }

  bool _multipleSelectionIsStart = false;
  bool get multipleSelectionIsStart => _multipleSelectionIsStart;
  set setMultipleSelectionIsStart(bool value) {
    _multipleSelectionIsStart = value;
    notifyListeners();
  }

  HashSet<ArticleModels> multipleSelection = HashSet();
  clearMultipleSelection() {
    multipleSelection.clear();
    print(multipleSelection);
    _multipleSelectionIsStart = false;
    notifyListeners();
  }

  void doMultiSelection(ArticleModels articleModels) {
    if (multipleSelection.contains(articleModels)) {
      multipleSelection.remove(articleModels);
    } else {
      multipleSelection.add(articleModels);
    }
    if (multipleSelection.isEmpty) {
      clearMultipleSelection();
    }
    notifyListeners();
  }
}
