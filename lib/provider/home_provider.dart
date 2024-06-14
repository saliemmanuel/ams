// ignore_for_file: deprecated_member_use

import 'dart:collection';

import 'package:ams/auth/firebase_auth.dart';
import 'package:ams/models/article_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/facture_client_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/bilan_facture_model.dart';
import '../models/user.dart';
import '../services/services_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    _multipleSelectionIsStart = false;
    notifyListeners();
  }

  void doMultiSelection(var articleModels) {
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

  bool _multipleSelectionIsStartInBilan = false;
  bool get multipleSelectionIsStartInBilan => _multipleSelectionIsStartInBilan;
  set setMultipleSelectionIsStartInBilan(bool value) {
    _multipleSelectionIsStartInBilan = value;
    notifyListeners();
  }

  HashSet<BilanFactureModel> multipleSelectionInBilan = HashSet();

  clearMultipleSelectionInBilan() {
    multipleSelectionInBilan.clear();
    _multipleSelectionIsStartInBilan = false;
    notifyListeners();
  }

  void doMultiSelectionInBilan(BilanFactureModel bilanFactureModel) {
    if (multipleSelectionInBilan.contains(bilanFactureModel)) {
      multipleSelectionInBilan.remove(bilanFactureModel);
    } else {
      multipleSelectionInBilan.add(bilanFactureModel);
    }
    if (multipleSelectionInBilan.isEmpty) {
      clearMultipleSelectionInBilan();
    }
    notifyListeners();
  }

  printPdf(HashSet<BilanFactureModel> multipleSelectionInBilan) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    for (var bilan in multipleSelectionInBilan) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            double beneficeT = 0.0;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          height: 90,
                          child: image1,
                        ),
                        pw.SizedBox(width: 20),
                        pw.Text(
                          "Bilan de Vente",
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                  ],
                ),
                pw.Text(bilan.nom,
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(bilan.telephone,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text("Factures:"),
                pw.Table.fromTextArray(
                  border: null,
                  headers: [
                    "Désignation",
                    "Prix V.",
                    "Prix A.",
                    "Qté",
                    "Remise",
                    "Béné./Articl.",
                    "Prix T./Articl."
                  ],
                  cellStyle: const pw.TextStyle(
                    color: PdfColors.black,
                  ),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data: bilan.facture.map((ele) {
                    double benefice = ((ele.articleModels!.prixVente! -
                                ele.articleModels!.prixAchat!) *
                            ele.quantite!) -
                        (ele.remise ?? 0);
                    beneficeT += benefice;
                    return [
                      ele.articleModels!.designation ?? 'N/A',
                      ele.articleModels!.prixVente?.toString() ?? 'N/A',
                      ele.articleModels!.prixAchat?.toString() ?? 'N/A',
                      ele.quantite?.toString() ?? 'N/A',
                      ele.remise?.toString() ?? 'N/A',
                      benefice.toStringAsFixed(2),
                      ele.prixTotal?.toString() ?? 'N/A'
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  border: null,
                  headers: ["", ""],
                  cellStyle: const pw.TextStyle(
                    color: PdfColors.black,
                  ),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data: [
                    ["Date", bilan.createAt],
                    ["Net Payer", bilan.netPayer.toString()],
                    ["Bénéfice", beneficeT.toStringAsFixed(2)]
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text("Vendeur: ${bilan.vendeur.nom ?? 'N/A'}"),
              ],
            );
          },
        ),
      );
    }
    await Printing.layoutPdf(
      name: 'Bilan de Vente du ${DateTime.now()}.pdf',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  printPdfSinglePage(BilanFactureModel bilan, bool isAdmin) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          double beneficeT = 0.0;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 90,
                        child: image1,
                      ),
                      pw.SizedBox(width: 20),
                      pw.Text(
                        "Bilan de Vente",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              ),
              pw.Text(bilan.nom,
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(bilan.telephone,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Factures:"),
              pw.Table.fromTextArray(
                border: null,
                headers: [
                  "Désignation",
                  isAdmin ? "Prix V." : null,
                  "Prix A.",
                  "Qté",
                  "Remise",
                  isAdmin ? "Béné./Articl." : null,
                  "Prix T./Articl."
                ],
                cellStyle: const pw.TextStyle(
                  color: PdfColors.black,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                data: bilan.facture.map((ele) {
                  double benefice = ((ele.articleModels!.prixVente! -
                              ele.articleModels!.prixAchat!) *
                          ele.quantite!) -
                      (ele.remise ?? 0);
                  beneficeT += benefice;
                  return [
                    ele.articleModels!.designation ?? 'N/A',
                    ele.articleModels!.prixVente?.toString() ?? 'N/A',
                    isAdmin
                        ? ele.articleModels!.prixAchat?.toString() ?? 'N/A'
                        : null,
                    ele.quantite?.toString() ?? 'N/A',
                    ele.remise?.toString() ?? 'N/A',
                    isAdmin ? benefice.toStringAsFixed(2) : null,
                    ele.prixTotal?.toString() ?? 'N/A'
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: null,
                headers: ["", ""],
                cellStyle: const pw.TextStyle(
                  color: PdfColors.black,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold
                ),
                data: [
                  ["Date", bilan.createAt],
                  ["Net Payer", bilan.netPayer.toString()],
                  ["Bénéfice", beneficeT.toStringAsFixed(2)]
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text("Vendeur: ${bilan.vendeur.nom ?? 'N/A'}"),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      name: 'Bilan de Vente du ${DateTime.now()}.pdf',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
