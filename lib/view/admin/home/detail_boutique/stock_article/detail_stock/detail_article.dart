import 'package:ams/models/article_modes.dart';
import 'package:ams/view/admin/widget/dialogue_ajout.dart';
import 'package:ams/view/admin/widget/edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../../services/service_locator.dart';
import '../../../../../../services/services_auth.dart';
import '../../../../../widgets/custom_layout_builder.dart';
import '../../../../../widgets/custom_text.dart';

class DetailAticle extends StatefulWidget {
  final ArticleModels article;
  final bool isVendeur;
  const DetailAticle(
      {super.key, required this.article, required this.isVendeur});

  @override
  State<DetailAticle> createState() => _DetailAticleState();
}

class _DetailAticleState extends State<DetailAticle> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Détail article"),
        ),
        body: StreamBuilder(
          stream: locator
              .get<ServiceAuth>()
              .firestore
              .collection('article')
              .where("id", isEqualTo: widget.article.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var article = ArticleModels.fromMap(snapshot.data!.docs[0].data());
              return ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                      height: 150.0,
                      child: Icon(IconlyBold.image_2, size: 120.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                          data: article.designation!,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                      Visibility(
                        visible: !widget.isVendeur,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            dialogueAjout2(
                                context: context,
                                child: EditeWidget(
                                    previusValue: article.designation!,
                                    isDouble: false,
                                    isString: true,
                                    value: "designation",
                                    label: "Nouveau nom",
                                    article: widget.article));
                          },
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: !widget.isVendeur,
                    child: DataTable(
                      showBottomBorder: true,
                      columns: const [
                        DataColumn(
                          label: CustomText(
                            data: "Désignation",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: CustomText(
                            data: "Valeur",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                      rows: [
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(CustomText(data: "Stock actuel")),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      data: article.stockActuel.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () {
                                      dialogueAjout2(
                                          context: context,
                                          child: EditeWidget(
                                              previusValue:
                                                  article.stockActuel.toString(),
                                              isString: false,
                                              isDouble: false,
                                              value: "stockActuel",
                                              label: "Nouveau Stock actuel",
                                              article: widget.article));
                                    },
                                  ),
                                ],
                              )),
                            ]),
                        DataRow(cells: [
                          const DataCell(CustomText(data: "Stock normal")),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(data: article.stockNormal.toString()),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  dialogueAjout2(
                                      context: context,
                                      child: EditeWidget(
                                          previusValue:
                                              article.stockNormal.toString(),
                                          isDouble: false,
                                          isString: false,
                                          value: "stockNormal",
                                          label: "Nouveau stock normal",
                                          article: widget.article));
                                },
                              ),
                            ],
                          )),
                        ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(CustomText(data: "Stock critique ")),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      data: article.stockCritique.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () {
                                      dialogueAjout2(
                                          context: context,
                                          child: EditeWidget(
                                              previusValue: article.stockCritique
                                                  .toString(),
                                              isDouble: false,
                                              isString: false,
                                              value: "stockCritique",
                                              label: "Nouveau stock critique",
                                              article: widget.article));
                                    },
                                  ),
                                ],
                              )),
                            ]),
                        DataRow(cells: [
                          const DataCell(CustomText(data: "Prix d'achat ")),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(data: article.prixAchat.toString()),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  dialogueAjout2(
                                      context: context,
                                      child: EditeWidget(
                                          previusValue:
                                              article.prixAchat.toString(),
                                          isDouble: true,
                                          isString: false,
                                          value: "prixAchat",
                                          label: "Nouveau prix d'achat",
                                          article: widget.article));
                                },
                              ),
                            ],
                          )),
                        ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(CustomText(data: "Prix de vente ")),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(data: article.prixVente.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () {
                                      dialogueAjout2(
                                          context: context,
                                          child: EditeWidget(
                                              previusValue:
                                                  article.prixVente.toString(),
                                              isDouble: true,
                                              isString: false,
                                              value: "prixVente",
                                              label: "Nouveau prix de vente",
                                              article: widget.article));
                                    },
                                  ),
                                ],
                              )),
                            ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.white),
                            cells: [
                              const DataCell(CustomText(data: "Bénéfice")),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      data: (article.prixVente! -
                                              article.prixAchat!)
                                          .toString()),
                                ],
                              )),
                            ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(
                                  CustomText(data: "Prix de vente non autorisé")),
                              DataCell(Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      data: article.prixNonAuto.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () {
                                      dialogueAjout2(
                                          context: context,
                                          child: EditeWidget(
                                              previusValue:
                                                  article.prixNonAuto.toString(),
                                              isDouble: true,
                                              isString: false,
                                              value: "prixNonAuto",
                                              label:
                                                  "Nouveau prix de vente non autorisé",
                                              article: widget.article));
                                    },
                                  ),
                                ],
                              )),
                            ]),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.isVendeur,
                    child: DataTable(
                      showBottomBorder: true,
                      columns: const [
                        DataColumn(
                          label: CustomText(
                            data: "Désignation",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DataColumn(
                          label: CustomText(
                            data: "Valeur",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                      rows: [
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(CustomText(data: "Stock actuel")),
                              DataCell(CustomText(
                                  data: article.stockActuel.toString())),
                            ]),
                        DataRow(cells: [
                          const DataCell(CustomText(data: "Stock normal")),
                          DataCell(
                              CustomText(data: article.stockNormal.toString())),
                        ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(CustomText(data: "Stock critique ")),
                              DataCell(CustomText(
                                  data: article.stockCritique.toString())),
                            ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.white),
                            cells: [
                              const DataCell(CustomText(data: "Prix de vente ")),
                              DataCell(
                                  CustomText(data: article.prixVente.toString())),
                            ]),
                        DataRow(
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              const DataCell(
                                  CustomText(data: "Prix de vente non autorisé")),
                              DataCell(CustomText(
                                  data: article.prixNonAuto.toString())),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0)
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
