import 'package:ams/models/boutique_model.dart';
import 'package:ams/view/admin/home/detail_boutique/bilan/bilan.dart';
import 'package:ams/view/admin/home/detail_boutique/liste_vendeur/liste_vendeur.dart';
import 'package:ams/view/admin/home/detail_boutique/stock_article/stock_article.dart';
import 'package:ams/view/admin/home/detail_boutique/widget/edite_boutique.dart';
import 'package:ams/view/admin/widget/dialogue_ajout.dart';
import 'package:ams/view/splash/splash.dart';
import 'package:ams/view/widgets/custom_dialogue_card.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../provider/home_provider.dart';
import '../../../../services/service_locator.dart';
import '../../../../services/services_auth.dart';
import '../../../widgets/custom_layout_builder.dart';
import '../../widget/home_card_widget.dart';

class DetailBoutique extends StatefulWidget {
  final BoutiqueModels boutique;
  const DetailBoutique({super.key, required this.boutique});

  @override
  State<DetailBoutique> createState() => _DetailBoutiqueState();
}

class _DetailBoutiqueState extends State<DetailBoutique> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: locator
                .get<ServiceAuth>()
                .firestore
                .collection("boutique")
                .where("id", isEqualTo: widget.boutique.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var boutique =
                    BoutiqueModels.fromMap(snapshot.data!.docs[0].data());
                return CustomText(data: boutique.nomBoutique!);
              }
              return const CupertinoActivityIndicator();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                dialogueAjout2(
                    child: EditeBoutique(boutiqueModels: widget.boutique),
                    context: context);
              },
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(width: 10.0)
          ],
        ),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                child: CustomLayoutBuilder(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      StreamBuilder(
                        stream: locator
                            .get<ServiceAuth>()
                            .firestore
                            .collection('boutique')
                            .where("id",
                                isEqualTo: locator
                                    .get<HomeProvider>()
                                    .boutiqueModels
                                    .id)
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
                            var boutique = BoutiqueModels.fromMap(
                                snapshot.data!.docs[0].data());
                            return HomeCardWidget(
                              label: "Vendeur",
                              onTap: () =>
                                  Get.to(() => ListVendeur(boutique: boutique)),
                              child: CustomText(
                                data: snapshot.data!.docs[0]['vendeur'].length
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 55.0,
                              ),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                      HomeCardWidget(
                        label: "Stock",
                        child: const Icon(Icons.storage_rounded, size: 85.0),
                        onTap: () {
                          Get.to(() => StockArticle(
                                boutique: widget.boutique,
                              ));
                        },
                      ),
                      HomeCardWidget(
                        label: "Bilan",
                        child: const Icon(Icons.assignment_turned_in_outlined,
                            size: 60.0),
                        onTap: () {
                          Get.to(() => Bilan(boutique: widget.boutique));
                        },
                      ),
                      // HomeCardWidget(
                      //   label: "Supprimer",
                      //   child: const Icon(Icons.delete_forever_outlined,
                      //       size: 60.0),
                      //   onTap: () {
                      //     deleteMultiple(idBoutique: widget.boutique.id);
                      //   },
                      // ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  deleteMultiple({idBoutique}) {
    confirmDialogue(
        panaraDialogType: PanaraDialogType.error,
        title: "Suppression",
        message: "Voulez-vous vraiment supprimer?",
        context: context,
        onTapConfirm: () {
          Get.to(() => const Splash());
          locator
              .get<ServiceAuth>()
              .deleteBoutique(context: context, idBoutique: idBoutique);
          locator.get<ServiceAuth>().showToast("Supprimé",
              context: context, position: FlutterToastr.bottom);
        });
  }
}
