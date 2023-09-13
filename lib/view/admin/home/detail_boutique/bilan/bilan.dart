import 'package:ams/models/bilan_facture_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/widget/bilan_facture_cart.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
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

  int nombrePiduit = 0;
  double valeurStock = 0.0;
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(data: "Bilan")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(onChanged: (value) {
              search = value;
              setState(() {});
            }),
            StreamBuilder(
              stream: locator
                  .get<ServiceAuth>()
                  .firestore
                  .collection('facture')
                  .where("idBoutique", isEqualTo: widget.boutique.id)
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
    );
  }
}
