import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/user.dart';
import 'package:ams/view/admin/home/ajout_boutique/ajout_boutique.dart';
import 'package:ams/view/admin/home/detail_boutique/detail_boutique.dart';
import 'package:ams/view/admin/home/liste_boutique/liste_boutique.dart';
import 'package:ams/view/admin/widget/boutique_card.dart';
import 'package:ams/view/admin/widget/dialogue_ajout.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../../services/services_auth.dart';
import '../../widgets/custom_search_bar.dart';
import '../widget/home_card_widget.dart';

class AdminHome extends StatefulWidget {
  final Users users;
  const AdminHome({super.key, required this.users});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int topIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Accueil"),
      ),
      body: Scrollbar(
        child: ListView(
          physics: const ScrollPhysics(),
          children: [
            CustomSearchBar(onTap: () {}),
            Container(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    HomeCardWidget(
                      label: "Boutique",
                      onTap: () {
                        dialogueAjout(
                            child: const AjoutBoutique(), context: context);
                      },
                      child: const Icon(Icons.add, size: 75.0),
                    ),
                    StreamBuilder(
                      stream: locator
                          .get<ServiceAuth>()
                          .firestore
                          .collection('boutique')
                          .where("idAdmin",
                              isEqualTo: locator.get<HomeProvider>().user.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            // Comptage
                            return HomeCardWidget(
                              label: "Boutique",
                              onTap: () {},
                              child: const CustomText(
                                data: "0",
                                overflow: TextOverflow.ellipsis,
                                fontSize: 55.0,
                              ),
                            );
                          }
                          return HomeCardWidget(
                            label: "Boutique",
                            onTap: () => Get.to(() => const ListBoutique()),
                            child: CustomText(
                              data: snapshot.data!.docs.length.toString(),
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
            const Divider(),
            const ListTile(
              title: CustomText(data: "Liste des Boutiques", fontSize: 18),
            ),
            StreamBuilder(
              stream: locator
                  .get<ServiceAuth>()
                  .firestore
                  .collection('boutique')
                  .where("idAdmin",
                      isEqualTo: locator.get<HomeProvider>().user.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: CustomText(
                        data: "Vous avez aucune boutique",
                        fontSize: 18,
                      )),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var boutique = BoutiqueModels.fromMap(
                            snapshot.data!.docs[index].data());
                        if (boutique.toJson().isNotEmpty) {
                          return BoutiqueCard(
                            nomBoutique: boutique.nomBoutique,
                            onTap: () {
                              locator.get<HomeProvider>().setBoutiqueModels =
                                  boutique;
                              Get.to(() => DetailBoutique(boutique: boutique));
                            },
                          );
                        } else {
                          return const Text("Une erreur s'est produite");
                        }
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
