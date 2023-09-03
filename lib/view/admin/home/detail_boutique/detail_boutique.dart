import 'package:ams/models/boutique_model.dart';
import 'package:ams/view/admin/home/detail_boutique/ajout_vendeur/ajout_vendeur.dart';
import 'package:ams/view/admin/home/detail_boutique/liste_vendeur/liste_vendeur.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../provider/home_provider.dart';
import '../../../../services/service_locator.dart';
import '../../../../services/services_auth.dart';
import '../../widget/dialogue_ajout.dart';
import '../../widget/home_card_widget.dart';
import '../ajout_boutique/ajout_boutique.dart';

class DetailBoutique extends StatefulWidget {
  const DetailBoutique({super.key});

  @override
  State<DetailBoutique> createState() => _DetailBoutiqueState();
}

class _DetailBoutiqueState extends State<DetailBoutique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            data: locator.get<HomeProvider>().boutiqueModels.nomBoutique!),
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  //Ajout vendeur
                  HomeCardWidget(
                      label: "Vendeur",
                      onTap: () {
                        dialogueAjout(
                            child: const AjoutVendeur(), context: context);
                      },
                      child: const Icon(Icons.add, size: 75.0)),
                  StreamBuilder(
                    stream: locator
                        .get<ServiceAuth>()
                        .firestore
                        .collection('boutique')
                        .where("id",
                            isEqualTo:
                                locator.get<HomeProvider>().boutiqueModels.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // Comptage des vendeurs
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return HomeCardWidget(
                            label: "Vendeur",
                            onTap: () {},
                            child: const CustomText(
                              data: "0",
                              overflow: TextOverflow.ellipsis,
                              fontSize: 55.0,
                            ),
                          );
                        }
                        return HomeCardWidget(
                          label: "Vendeur",
                          onTap: () => Get.to(() => ListVendeur(
                              boutique: BoutiqueModels.fromMap(
                                  snapshot.data!.docs[0].data()))),
                          child: CustomText(
                            data: snapshot.data!.docs[0]['vendeur'].length
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 55.0,
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
