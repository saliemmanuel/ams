import 'package:ams/models/bilan_facture_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/widget/bilan_facture_cart.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_date_widget.dart';
import '../../../../widgets/custom_layout_builder.dart';
import '../../../../widgets/custom_search_bar.dart';
import 'detail_bilan/detail_bilan.dart';

class Bilan extends StatefulWidget {
  final BoutiqueModels boutique;
  const Bilan({super.key, required this.boutique});

  @override
  State<Bilan> createState() => _BilanState();
}

class _BilanState extends State<Bilan> {
  @override
  void initState() {
    buildBenefice();
    super.initState();
  }

  int nombrePiduit = 0;
  double valeurStock = 0.0;
  String search = "";
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Bilan"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Expanded(
              //       child: CustomDetailWidget(
              //         title: "Du",
              //         nullVal: "Date",
              //         subtitle: selectedDate,
              //         onTap: () {
              //           _selectDate(context);
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 8.0),
              //     Expanded(
              //       child: CustomDetailWidget(
              //         title: "Au",
              //         nullVal: "Date",
              //         subtitle: selectedDate2,
              //         onTap: () {
              //           _selectDate2(context);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              CustomSearchBar(onChanged: (value) {
                search = value;
                setState(() {});
              }),
              StreamBuilder(
                stream: locator
                    .get<ServiceAuth>()
                    .firestore
                    .collection("facture")
                    .where("idBoutique", isEqualTo: widget.boutique.id)
                    .orderBy("createAt", descending: false)
                    .snapshots(),
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
                                    return BilanFactureCard(
                                      bilanFactureModel: bilanFactureModel,
                                      onTap: () {
                                        Get.to(() => DetailBilan(
                                            bilanFactureModel:
                                                bilanFactureModel));
                                      },
                                    );
                                  }
                                  if (bilanFactureModel.nom
                                      .toLowerCase()
                                      .contains(search.toLowerCase())) {
                                    return BilanFactureCard(
                                      bilanFactureModel: bilanFactureModel,
                                      onTap: () {
                                        Get.to(() => DetailBilan(
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
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: DataTable(showBottomBorder: true, columns: const [
                DataColumn(
                    label:
                        CustomText(data: "Bénéfice", fontWeight: FontWeight.bold))
              ], rows: [
                DataRow(cells: [
                  DataCell(
                    AnimatedDigitWidget(
                      value: beneficeT,
                      controller: _controller,
                      fractionDigits: 2,
                      enableSeparator: true,
                    ),
                  )
                ])
              ]),
            ),
          ],
        ),
      ),
    );
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

  final _controller = AnimatedDigitController(0);

  double beneficeT = 0.0;
  buildBenefice() async {
    var data = await locator
        .get<ServiceAuth>()
        .firestore
        .collection("facture")
        .where("idBoutique", isEqualTo: widget.boutique.id)
        .get();

    for (var value in data.docs) {
      var bilanFactureModel = BilanFactureModel.fromMap(value.data());
      for (var ele in bilanFactureModel.facture) {
        beneficeT +=
            ((ele.articleModels!.prixVente! - ele.articleModels!.prixAchat!) *
                ele.quantite!);
      }
      _controller.value = beneficeT;
      setState(() {});
    }
  }
}
