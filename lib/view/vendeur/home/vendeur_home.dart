import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/user.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/vendeur/home/nouvelle_facture/nouvelle_facture.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/article_modes.dart';
import '../../../services/service_locator.dart';
import '../../../services/services_auth.dart';
import '../../admin/home/detail_boutique/stock_article/detail_stock/detail_article.dart';
import '../../admin/home/detail_boutique/stock_article/stock_article.dart';
import '../../widgets/custom_layout_builder.dart';
import '../../widgets/custom_search_bar.dart';
import '../widget/article_card_home_vendeur.dart';

class VendeurHome extends StatefulWidget {
  final Users users;
  final BoutiqueModels boutique;
  const VendeurHome({super.key, required this.users, required this.boutique});

  @override
  State<VendeurHome> createState() => _VendeurHomeState();
}

class _VendeurHomeState extends State<VendeurHome> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(data: widget.boutique.nomBoutique!),
          actions: [
            const SizedBox(width: 15.0),
            DropdownButton(
                hint: CustomText(data: selectedItem),
                items: const [
                  DropdownMenuItem(
                    value: "Disponible",
                    child: CustomText(data: 'Disponible'),
                  ),
                  DropdownMenuItem(
                    value: "Epuiser",
                    child: CustomText(data: 'Epuiser'),
                  ),
                  DropdownMenuItem(
                    value: "Critique",
                    child: CustomText(data: 'Critique'),
                  ),
                  DropdownMenuItem(
                    value: "Tous",
                    child: CustomText(data: 'Tous'),
                  ),
                ],
                onChanged: (v) {
                  selectedItem = v!;
                  setState(() {});
                }),
            const SizedBox(width: 15.0),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSearchBar(onChanged: (value) {
                  search = value;
                  setState(() {});
                }),
                StreamBuilder(
                    stream: getStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: CustomText(
                                    data: "Vous avez aucun article",
                                    fontSize: 18)),
                          );
                        }
                        return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var articleModels = ArticleModels.fromMap(
                                snapshot.data!.docs[index].data());
                            if (search.isEmpty) {
                              return ArticleCardHomeVendeur(
                                onTap: () => Get.to(() => DetailAticle(
                                    isVendeur: true, article: articleModels)),
                                articleModels: articleModels,
                                colorIcon: selectedItem == "Epuiser"
                                    ? Colors.red
                                    : articleModels.stockActuel == 0
                                        ? Colors.red
                                        : Colors.white,
                                onPressed: (selectedItem == "Epuiser" ||
                                        articleModels.stockActuel == 0)
                                    ? null
                                    : () {
                                        if (!Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .listArticleVente!
                                            .contains(articleModels)) {
                                          HapticFeedback.mediumImpact();
    
                                          locator.get<ServiceAuth>().showToast(
                                              "Ajouté",
                                              context: context,
                                              position: FlutterToastr.bottom);
                                          Provider.of<HomeProvider>(context,
                                                  listen: false)
                                              .setValeurListArticleVente(
                                                  articleModels);
                                        } else {
                                          locator.get<ServiceAuth>().showToast(
                                              context: context,
                                              "Déjà dans la facture",
                                              position: FlutterToastr.bottom);
                                        }
                                      },
                              );
                            }
                            if (articleModels.designation!
                                .toLowerCase()
                                .contains(search.toLowerCase())) {
                              return ArticleCardHomeVendeur(
                                onTap: () => Get.to(() => DetailAticle(
                                    isVendeur: true, article: articleModels)),
                                articleModels: articleModels,
                                colorIcon: selectedItem == "Epuiser"
                                    ? Colors.grey
                                    : articleModels.stockActuel == 0
                                        ? Colors.grey
                                        : Colors.white,
                                onPressed: (selectedItem == "Epuiser" ||
                                        articleModels.stockActuel == 0)
                                    ? null
                                    : () {
                                        if (!Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .listArticleVente!
                                            .contains(articleModels)) {
                                          locator.get<ServiceAuth>().showToast(
                                              "Ajouté",
                                              context: context,
                                              position: FlutterToastr.bottom);
                                          Provider.of<HomeProvider>(context,
                                                  listen: false)
                                              .setValeurListArticleVente(
                                                  articleModels);
                                        } else {
                                          locator.get<ServiceAuth>().showToast(
                                              context: context,
                                              "Déjà dans la facture",
                                              position: FlutterToastr.bottom);
                                        }
                                      },
                              );
                            }
                            return const SizedBox();
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                const SizedBox(height: 100.0)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FilledButton.tonalIcon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Get.to(() => NouvelleFacture(boutiqueModels: widget.boutique));
            },
            icon: const Icon(Icons.assignment_outlined),
            label: const CustomText(data: "Facture")),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    if (selectedItem == "Disponible") {
      return locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .where("stockActuel", isGreaterThanOrEqualTo: 1)
          .snapshots();
    } else if (selectedItem == "Epuiser") {
      return locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .where("stockActuel", isEqualTo: 0)
          .snapshots();
    } else if (selectedItem == "Critique") {
      return locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id).
          where('stockActuel', isLessThanOrEqualTo: 1)
          .snapshots();
    } else if (selectedItem == "Tous") {
      return locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .snapshots();
    } else {
      return locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isGreaterThan: widget.boutique.id)
          .snapshots();
    }
  }
}
