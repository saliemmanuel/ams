import 'package:ams/models/bilan_facture_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/widget/bilan_facture_cart.dart';
import 'package:ams/view/vendeur/bilan/widget/bilan_facture_cart.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:ams/view/widgets/formate_date.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../widgets/custom_date_widget.dart';
import '../../widgets/custom_search_bar.dart';
import 'detail_bilan/detail_bilan.dart';

class BilanVendeur extends StatefulWidget {
  final BoutiqueModels boutique;
  const BilanVendeur({super.key, required this.boutique});

  @override
  State<BilanVendeur> createState() => _BilanVendeurState();
}

class _BilanVendeurState extends State<BilanVendeur> {
  String search = "";
  List listJour = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "28",
    "30",
    "31",
  ];
  String selectedDay = "Jour";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Mes ventes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomDetailWidget(
                    title: "Du",
                    nullVal: "Date",
                    subtitle: selectedDate,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: CustomDetailWidget(
                    title: "Au",
                    nullVal: "Date",
                    subtitle: selectedDate2,
                    onTap: () {
                      _selectDate2(context);
                    },
                  ),
                ),
              ],
            ),
            CustomSearchBar(onChanged: (value) {
              search = value;
              setState(() {});
            }),
            StreamBuilder(
              stream: getStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: CustomText(
                        data: "Aucune facture",
                        fontSize: 18,
                      )),
                    );
                  }
                  return Column(
                    children: [
                      Scrollbar(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const PageScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var bilanFactureModel = BilanFactureModel.fromMap(
                                  snapshot.data!.docs[index].data());

                              if (bilanFactureModel.toJson().isNotEmpty) {
                                if (search.isEmpty) {
                                  return BilanFactureVendeurCard(
                                    bilanFactureModel: bilanFactureModel,
                                    onTap: () {
                                      Get.to(() => DetailBilanVendeux(
                                          bilanFactureModel:
                                              bilanFactureModel));
                                    },
                                  );
                                }
                                if (bilanFactureModel.nom
                                    .toLowerCase()
                                    .contains(search.toLowerCase())) {
                                  return BilanFactureVendeurCard(
                                    bilanFactureModel: bilanFactureModel,
                                    onTap: () {
                                      Get.to(() => DetailBilanVendeux(
                                          bilanFactureModel:
                                              bilanFactureModel));
                                    },
                                  );
                                }
                                return const SizedBox();
                              } else {
                                return const Center(
                                  child: CustomText(
                                      data: "Une erreur s'est produite"),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 100.0)
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    setState(() {});
    print(selectedDate);
    return locator
        .get<ServiceAuth>()
        .firestore
        .collection("facture")
        // .where("idBoutique", isEqualTo: widget.boutique.id)
        .where("createAt", isGreaterThanOrEqualTo: selectedDate)
        .where("createAt", isLessThanOrEqualTo: "30-Sep-2023 ")
        .orderBy("createAt", descending: false)
        .snapshots();
  }

  dynamic selectedDate;
  dynamic selectedDate2;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = '${picked.day}-${picked.month}-${picked.year} ';
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate2) {
      setState(() {
        selectedDate2 = '${picked.day}-${picked.month}-${picked.year} ';
      });
    }
  }
}
