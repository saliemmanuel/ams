import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';

import '../../../../../../models/bilan_facture_model.dart';
import '../../../../../../models/boutique_model.dart';
import '../../../../../../services/service_locator.dart';
import '../../../../../../services/services_auth.dart';
import '../../../../../widgets/widgets.dart';

class DetailBenefice extends StatefulWidget {
  final BoutiqueModels boutique;

  const DetailBenefice({super.key, required this.boutique});

  @override
  State<DetailBenefice> createState() => _DetailBeneficeState();
}

class _DetailBeneficeState extends State<DetailBenefice> {
  double totalVentes = 0;
  double beneficeT = 0.0;

  @override
  void initState() {
    buildBeneficeFacture();
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
                            data: "TOTAL VENTES", fontWeight: FontWeight.bold))
                  ], rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        totalVentes.toString(),
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
                            data: "BENEFICE", fontWeight: FontWeight.bold))
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
          ],
        ),
      ),
    );
  }

  buildBeneficeFacture() async {
    print("object");
    var data = await locator
        .get<ServiceAuth>()
        .firestore
        .collection("facture")
        .where("idBoutique", isEqualTo: widget.boutique.id)
        .get();

    for (var value in data.docs) {
      var bilanFactureModel = BilanFactureModel.fromMap(value.data());
      totalVentes += bilanFactureModel.netPayer;
      for (var ele in bilanFactureModel.facture) {
        beneficeT +=
            ((ele.articleModels!.prixVente! - ele.articleModels!.prixAchat!) *
                ele.quantite!);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }
}
