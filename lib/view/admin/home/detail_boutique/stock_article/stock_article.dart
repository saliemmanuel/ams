import 'dart:async';

import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/admin/home/detail_boutique/stock_article/detail_stock/detail_article.dart';
import 'package:ams/view/admin/widget/article_card.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_search_bar.dart';
import '../../../widget/dialogue_ajout.dart';
import 'ajout_article/ajout_article.dart';

class StockArticle extends StatefulWidget {
  final BoutiqueModels boutique;
  const StockArticle({super.key, required this.boutique});

  @override
  State<StockArticle> createState() => _StockArticleState();
}

String selectedItem = 'Disponible';

class _StockArticleState extends State<StockArticle> {
  @override
  void initState() {
    calculValeurStock();
    super.initState();
  }

  int nombrePiduit = 0;
  double valeurStock = 0.0;
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Stock"),
          actions: [
            FilledButton(
                onPressed: () {
                  dialogueAjout(
                      child: AjoutArticle(boutique: widget.boutique),
                      context: context);
                },
                child: const CustomText(data: "Ajouter", color: Colors.white)),
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
                    value: "Tous",
                    child: CustomText(data: 'Tous'),
                  ),
                ],
                onChanged: (v) {
                  selectedItem = v!;

                  calculValeurStock();
                  setState(() {});
                }),
            const SizedBox(width: 15.0),
          ],
        ),
        body: SingleChildScrollView(
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
                                var articleModels = ArticleModels.fromMap(
                                    snapshot.data!.docs[index].data());
                                if (articleModels.toJson().isNotEmpty) {
                                  if (search.isEmpty) {
                                    return ArticleCard(
                                      articleModels: articleModels,
                                      onTap: () {
                                        Get.to(() => DetailAticle(
                                            isVendeur: false,
                                            article: articleModels));
                                      },
                                    );
                                  }
                                  if (articleModels.designation!
                                      .toLowerCase()
                                      .contains(search.toLowerCase())) {
                                    return ArticleCard(
                                      articleModels: articleModels,
                                      onTap: () {
                                        Get.to(() => DetailAticle(
                                            isVendeur: false,
                                            article: articleModels));
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
        persistentFooterButtons: [
          Consumer<HomeProvider>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DataTable(showBottomBorder: true, columns: const [
                      DataColumn(
                        label: CustomText(
                            data: "Nombre Produit",
                            fontWeight: FontWeight.bold),
                      ),
                      DataColumn(
                          label: CustomText(
                              data: "Valeur du stock",
                              fontWeight: FontWeight.bold))
                    ], rows: [
                      DataRow(cells: [
                        DataCell(Center(
                          child: StreamBuilder(
                            stream: getStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CustomText(
                                      data: "0",
                                    )),
                                  );
                                }
                                return Center(
                                    child: CustomText(
                                        data: snapshot.data!.docs.length
                                            .toString()));
                              }
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            },
                          ),
                        )),
                        selectedItem == "Epuiser"
                            ? const DataCell(
                                Center(child: Text("0")),
                              )
                            : DataCell(
                                Center(
                                    child: valeurStock == 0.0
                                        ? const CupertinoActivityIndicator()
                                        : Text(valeurStock.toString())),
                              ),
                      ])
                    ]),
                  ),
                ],
              );
            },
          )
        ]);
  }

  calculValeurStock() async {
    valeurStock = 0.0;
    if (selectedItem == "Disponible") {
      await locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .where("stockActuel", isGreaterThanOrEqualTo: 1)
          .get()
          .then((value) {
        for (var element in value.docs) {
          valeurStock +=
              (element.data()['prixVente'] * element.data()['stockActuel']);
        }
      });
    }
    if (selectedItem == "Epuiser") {
      await locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .where("stockActuel", isEqualTo: 0)
          .get()
          .then((value) {
        for (var element in value.docs) {
          valeurStock +=
              (element.data()['prixVente'] * element.data()['stockActuel']);
        }
      });
    }
    if (selectedItem == "Tous") {
      await locator
          .get<ServiceAuth>()
          .firestore
          .collection('article')
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .get()
          .then((value) {
        for (var element in value.docs) {
          valeurStock +=
              (element.data()['prixVente'] * element.data()['stockActuel']);
        }
      });
    }
    if (mounted) {
      setState(() {});
    }
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
          .where("idBoutique", isEqualTo: widget.boutique.id)
          .snapshots();
    }
  }
}
