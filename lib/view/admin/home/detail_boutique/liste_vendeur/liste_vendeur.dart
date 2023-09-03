import 'package:ams/models/vendeur_model.dart';
import 'package:ams/view/admin/widget/vendeur_card.dart';
import 'package:flutter/material.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:get/get.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_text.dart';
import '../../../widget/home_card_widget.dart';

class ListVendeur extends StatefulWidget {
  final BoutiqueModels boutique;
  const ListVendeur({
    Key? key,
    required this.boutique,
  }) : super(key: key);

  @override
  State<ListVendeur> createState() => _ListVendeurState();
}

class _ListVendeurState extends State<ListVendeur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Liste vendeur Boutiques"),
      ),
      body: StreamBuilder(
        stream: locator
            .get<ServiceAuth>()
            .firestore
            .collection('boutique')
            .where("id", isEqualTo: widget.boutique.id)
            .snapshots(),
        builder: (context, snapshot) {
          // Comptage des vendeurs
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Text("Vous avez aucun vendeur dans la boutique");
            }
            var boutique =
                BoutiqueModels.fromMap(snapshot.data!.docs[0].data());
            if (boutique.vendeur!.isNotEmpty) {
              return StreamBuilder(
                stream: locator
                    .get<ServiceAuth>()
                    .firestore
                    .collection('users')
                    .where("id", whereIn: boutique.vendeur)
                    .snapshots(),
                builder: (context, snap) {
                  // Comptage des vendeurs
                  if (snap.hasData) {
                    if (snap.data!.docs.isEmpty) {
                      return const Text(
                          "Vous avez aucun vendeur dans la boutique");
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (context, i) {
                          var vendeur =
                              Vendeur.fromMap(snap.data!.docs[i].data());

                          return VendeurCard(
                              boutiqueModels: boutique,
                              vendeur: vendeur,
                              onTap: () {});
                        },
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return const Align(
              alignment: Alignment.center,
              child: CustomText(data: "Vous avec aucun vendeur ", fontSize: 18),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
