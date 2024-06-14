import 'dart:collection';

import 'package:ams/models/bilan_facture_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/widget/bilan_facture_cart.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/widget/detail_benefice.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_dialogue_card.dart';
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
    super.initState();
  }

  String search = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) => CustomLayoutBuilder(
        child: Scaffold(
          appBar: AppBar(
            title: const CustomText(data: "Bilan"),
            actions: [
              Visibility(
                visible: value.multipleSelectionIsStartInBilan,
                child: Row(
                  children: [
                    FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.green)),
                      child: const Icon(Icons.print),
                      onPressed: () {
                        value.printPdf(value.multipleSelectionInBilan);
                      },
                    ),
                    const SizedBox(width: 10.0),
                    FilledButton(
                      onPressed: () {
                        deleteMultiple(value.multipleSelectionInBilan);
                      },
                      child: const Icon(Icons.delete_forever),
                    ),
                    const SizedBox(width: 10.0),
                    FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.redAccent)),
                      onPressed: () {
                        value.clearMultipleSelectionInBilan();
                      },
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25.0),
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
                                  var bilanFactureModel =
                                      BilanFactureModel.fromMap(
                                          snapshot.data!.docs[index].data());

                                  if (bilanFactureModel.toJson().isNotEmpty) {
                                    if (search.isEmpty) {
                                      return BilanFactureCard(
                                        isSelected: value
                                                .multipleSelectionInBilan
                                                .contains(bilanFactureModel)
                                            ? true
                                            : false,
                                        onLongPress: () {
                                          value.doMultiSelectionInBilan(
                                              bilanFactureModel);
                                          value.setMultipleSelectionIsStartInBilan =
                                              true;
                                          HapticFeedback.mediumImpact();
                                        },
                                        bilanFactureModel: bilanFactureModel,
                                        onTap: () {
                                          if (!value
                                              .multipleSelectionIsStartInBilan) {
                                            Get.to(() => DetailBilan(
                                                bilanFactureModel:
                                                    bilanFactureModel));
                                          } else {
                                            value.doMultiSelectionInBilan(
                                                bilanFactureModel);
                                            HapticFeedback.mediumImpact();
                                          }
                                        },
                                      );
                                    }
                                    if (bilanFactureModel.nom
                                        .toLowerCase()
                                        .contains(search.toLowerCase())) {
                                      return BilanFactureCard(
                                        isSelected: value
                                                .multipleSelectionInBilan
                                                .contains(bilanFactureModel)
                                            ? true
                                            : false,
                                        onLongPress: () {
                                          value.doMultiSelectionInBilan(
                                              bilanFactureModel);
                                          value.setMultipleSelectionIsStartInBilan =
                                              true;
                                          HapticFeedback.mediumImpact();
                                        },
                                        bilanFactureModel: bilanFactureModel,
                                        onTap: () {
                                          if (!value
                                              .multipleSelectionIsStartInBilan) {
                                            Get.to(() => DetailBilan(
                                                bilanFactureModel:
                                                    bilanFactureModel));
                                          } else {
                                            value.doMultiSelectionInBilan(
                                                bilanFactureModel);
                                            HapticFeedback.mediumImpact();
                                          }
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.to(() => DetailBenefice(boutique: widget.boutique));
            },
            label: const Text("Plus de détail"),
          ),
        ),
      ),
    );
  }

  deleteMultiple(HashSet<BilanFactureModel>? multipleSelection) {
    confirmDialogue(
        panaraDialogType: PanaraDialogType.error,
        title: "Suppression",
        message: "Voulez-vous vraiment supprimer?",
        context: context,
        onTapConfirm: () {
          locator.get<ServiceAuth>().deleteMultipleInBilan(
              context: context, multipleSelection: multipleSelection);
          locator.get<ServiceAuth>().showToast("Supprimé",
              context: context, position: FlutterToastr.bottom);
        });
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
