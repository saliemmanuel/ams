import 'package:ams/models/article_model.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/bilan_facture_model.dart';
import '../../../../../../models/boutique_model.dart';
import '../../../../../../services/service_locator.dart';
import '../../../../../../services/services_auth.dart';
import '../../../../../provider/home_provider.dart';
import '../../../../widgets/widgets.dart';

class BeneficeStock extends StatefulWidget {
  final BoutiqueModels boutique;

  const BeneficeStock({super.key, required this.boutique});

  @override
  State<BeneficeStock> createState() => _BeneficeStockState();
}

class _BeneficeStockState extends State<BeneficeStock> {
  int nombreProduit = 0;
  double valeurStock = 0.0;
  double beneficeT = 0.0;

  @override
  void initState() {
    buildBenefice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail benefice"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DataTable(showBottomBorder: true, columns: const [
                    DataColumn(
                        label: CustomText(
                            data: "Nombre Produit",
                            fontWeight: FontWeight.bold))
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        nombreProduit.toString(),
                        style: const TextStyle(fontSize: 22.0),
                      ))
                    ])
                  ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DataTable(showBottomBorder: true, columns: const [
                    DataColumn(
                        label: CustomText(
                            data: "Bénéfice", fontWeight: FontWeight.bold))
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        beneficeT.toString(),
                        style: const TextStyle(fontSize: 22.0),
                      ))
                    ])
                  ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DataTable(showBottomBorder: true, columns: const [
                    DataColumn(
                        label: CustomText(
                            data: "Valeur Stock", fontWeight: FontWeight.bold))
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        valeurStock.toString(),
                        style: const TextStyle(fontSize: 22.0),
                      ))
                    ])
                  ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DataTable(showBottomBorder: true, columns: const [
                    DataColumn(
                        label: CustomText(
                            data: "Valeur total", fontWeight: FontWeight.bold))
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        (valeurStock + beneficeT).toString(),
                        style: const TextStyle(fontSize: 22.0),
                      ))
                    ])
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildBenefice() async {
    var data = await locator
        .get<ServiceAuth>()
        .firestore
        .collection("article")
        .where("idBoutique", isEqualTo: widget.boutique.id)
        .get();
    for (var value in data.docs) {
      nombreProduit += 1;
      var article = ArticleModels.fromMap(value.data());
      valeurStock += article.prixAchat! * article.stockActuel!;
      beneficeT +=
          ((article.prixVente! - article.prixAchat!) * article.stockActuel!);
    }

    setState(() {});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return locator
        .get<ServiceAuth>()
        .firestore
        .collection('article')
        .where("idBoutique", isEqualTo: widget.boutique.id)
        .snapshots();
  }
}
