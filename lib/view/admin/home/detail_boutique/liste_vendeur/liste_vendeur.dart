import 'package:ams/models/vendeur_model.dart';
import 'package:ams/themes/theme.dart';
import 'package:ams/view/admin/widget/vendeur_card.dart';
import 'package:flutter/material.dart';
import 'package:ams/models/boutique_model.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_layout_builder.dart';
import '../../../../widgets/custom_text.dart';
import '../../../widget/dialogue_ajout.dart';
import '../ajout_vendeur/ajout_vendeur.dart';

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
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Vendeur boutiques"),
          actions: [
            IconButton.filled(
                color: Palette.primary,
                onPressed: () {
                  dialogueAjout(child: const AjoutVendeur(), context: context);
                },
                icon: const Icon(Icons.add, color: Colors.white)),
            const SizedBox(width: 15.0)
          ],
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
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CustomText(
                                fontSize: 22.0,
                                data: "Vous avez aucun vendeur dans la boutique"),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
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
      ),
    );
  }
}
