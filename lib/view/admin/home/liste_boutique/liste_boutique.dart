import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../models/boutique_model.dart';
import '../../../../models/user.dart';
import '../../../../provider/home_provider.dart';
import '../../../../services/service_locator.dart';
import '../../../../services/services_auth.dart';
import '../../../widgets/custom_dialogue_card.dart';
import '../../../widgets/custom_layout_builder.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/verif_code_user.dart';
import '../../widget/boutique_card.dart';
import '../../widget/dialogue_ajout.dart';
import '../detail_boutique/detail_boutique.dart';

class ListBoutique extends StatefulWidget {
  final Users users;

  const ListBoutique({super.key, required this.users});

  @override
  State<ListBoutique> createState() => _ListBoutiqueState();
}

class _ListBoutiqueState extends State<ListBoutique> {
  String search = "";
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Liste Boutiques"),
        ),
        body: Column(
          children: [
            CustomSearchBar(onChanged: (value) {
              search = value;
              setState(() {});
            }),
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
                          if (search.isEmpty) {
                            return BoutiqueCard(
                              nomBoutique: boutique.nomBoutique,
                              onTap: () {
                                locator.get<HomeProvider>().setBoutiqueModels =
                                    boutique;
                                Get.to(
                                    () => DetailBoutique(boutique: boutique));
                                // dialogueAjout2(
                                //     context: context,
                                //     child: VerifCodeUser(
                                //         users: widget.users,
                                //         callBack: (value) {
                                //           if (value) {
                                //             Get.back();
                                //             locator
                                //                 .get<HomeProvider>()
                                //                 .setBoutiqueModels = boutique;
                                //             Get.to(() => DetailBoutique(
                                //                 boutique: boutique));
                                //           } else {
                                //             dialogueAndonTapDismiss(
                                //                 onTapDismiss: () {
                                //                   Get.back();
                                //                 },
                                //                 panaraDialogType:
                                //                     PanaraDialogType.error,
                                //                 message: "Code secret incorrect",
                                //                 title: "",
                                //                 context: context);
                                //           }
                                //         }));
                              },
                            );
                          }
                          if (boutique.nomBoutique!
                              .toLowerCase()
                              .contains(search.toLowerCase())) {
                            return BoutiqueCard(
                              nomBoutique: boutique.nomBoutique,
                              onTap: () {
                                locator.get<HomeProvider>().setBoutiqueModels =
                                    boutique;
                                Get.to(
                                    () => DetailBoutique(boutique: boutique));
                              },
                            );
                          }
                          return const SizedBox();
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
