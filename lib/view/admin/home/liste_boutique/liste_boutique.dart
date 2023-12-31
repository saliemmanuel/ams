import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../models/boutique_model.dart';
import '../../../../provider/home_provider.dart';
import '../../../../services/service_locator.dart';
import '../../../../services/services_auth.dart';
import '../../../widgets/custom_dialogue_card.dart';
import '../../../widgets/verif_code_user.dart';
import '../../widget/boutique_card.dart';
import '../../widget/dialogue_ajout.dart';
import '../detail_boutique/detail_boutique.dart';

class ListBoutique extends StatefulWidget {
  const ListBoutique({super.key});

  @override
  State<ListBoutique> createState() => _ListBoutiqueState();
}

class _ListBoutiqueState extends State<ListBoutique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Liste Boutiques"),
      ),
      body: StreamBuilder(
        stream: locator
            .get<ServiceAuth>()
            .firestore
            .collection('boutique')
            .where("idAdmin", isEqualTo: locator.get<HomeProvider>().user.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Text("Vous avez aucune boutique");
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var boutique = BoutiqueModels.fromMap(
                        snapshot.data!.docs[index].data());
                    if (boutique.toJson().isNotEmpty) {
                      return BoutiqueCard(
                        nomBoutique: boutique.nomBoutique,
                        onTap: () {
                          dialogueAjout2(
                              context: context,
                              child: VerifCodeUser(
                                  users: locator.get<HomeProvider>().user,
                                  callBack: (value) {
                                    if (value) {
                                      Get.back();
                                      locator
                                          .get<HomeProvider>()
                                          .setBoutiqueModels = boutique;
                                      Get.to(() =>
                                          DetailBoutique(boutique: boutique));
                                    } else {
                                      dialogueAndonTapDismiss(
                                          onTapDismiss: () {
                                            Get.back();
                                          },
                                          panaraDialogType:
                                              PanaraDialogType.error,
                                          message: "Code secret incorrect",
                                          title: "",
                                          context: context);
                                    }
                                  }));
                        },
                      );
                    } else {
                      return const Text("Une erreur s'est produite");
                    }
                  },
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
