import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../models/article_model.dart';
import '../../../../../models/vendeur_model.dart';
import '../../../../../provider/home_provider.dart';
import '../../../../admin/home/detail_boutique/stock_article/detail_stock/detail_article.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_layout_builder.dart';

class RecapitulatifFacture extends StatefulWidget {
  final String nom, telephone, idBoutique;
  final Vendeur? vendeur;
  const RecapitulatifFacture(
      {super.key,
      required this.nom,
      required this.telephone,
      required this.idBoutique,
      required this.vendeur});

  @override
  State<RecapitulatifFacture> createState() => _RecapitulatifFactureState();
}

class _RecapitulatifFactureState extends State<RecapitulatifFacture> {
  // ce widget est la pour les line intérrompu
  Widget dotWidget = Container(
    decoration:
        DottedDecoration(shape: Shape.line, linePosition: LinePosition.bottom),
    width: double.infinity,
  );

  // pour la somme du net à payer par le client
  double netAPayer = 0.0;
  @override
  void initState() {
    calculeNetAPayer();
    super.initState();
  }

  calculeNetAPayer() {
    // je parcours la liste de la factures globale
    for (var element
        in Provider.of<HomeProvider>(context, listen: false).echoVal) {
      // je fait la somme des prixTotal
      netAPayer += double.parse(element.prixTotal.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 10.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(data: "1/1"),
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              data: "Récapitulatif de la facture",
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10.0),
                            dotWidget,
                            const SizedBox(height: 10.0),
                            CustomText(
                              data: "Nom client : ${widget.nom}",
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 15.0),
                            CustomText(
                              data: "Téléphone : ${widget.telephone}",
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 15.0),
                            dotWidget,
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTablePlus(
                                columns: const [
                                  DataColumnPlus(label: Text('N°')),
                                  DataColumnPlus(label: Text('Désignation')),
                                  DataColumn(label: Text('Qté')),
                                  DataColumn(label: Text('Prix T.')),
                                ],
                                rows: List<DataRow>.generate(
                                    Provider.of<HomeProvider>(context,
                                            listen: false)
                                        .echoVal
                                        .length, (index) {
                                  var articleModels = ArticleModels.fromMap(
                                      Provider.of<HomeProvider>(context,
                                              listen: false)
                                          .echoVal[index]
                                          .articleModels!
                                          .toMap());
                                  return DataRow(
                                      color: index % 2 != 0
                                          ? MaterialStateProperty.all(
                                              Colors.white)
                                          : MaterialStateProperty.all(
                                              Colors.grey.shade200),
                                      cells: [
                                        DataCell(
                                          Text((index + 1).toString()),
                                          onTap: () {
                                            Get.to(() => DetailAticle(
                                                isVendeur: true,
                                                article: articleModels));
                                          },
                                        ),
                                        DataCell(
                                          CustomText(
                                              data: articleModels.designation!),
                                          onTap: () {
                                            Get.to(() => DetailAticle(
                                                isVendeur: true,
                                                article: articleModels));
                                          },
                                        ),
                                        DataCell(
                                          CustomText(
                                              data: Provider.of<HomeProvider>(
                                                      context,
                                                      listen: false)
                                                  .echoVal[index]
                                                  .quantite
                                                  .toString()),
                                          onTap: () {
                                            Get.to(() => DetailAticle(
                                                isVendeur: true,
                                                article: articleModels));
                                          },
                                        ),
                                        DataCell(
                                          CustomText(
                                              data: Provider.of<HomeProvider>(
                                                      context,
                                                      listen: false)
                                                  .echoVal[index]
                                                  .prixTotal
                                                  .toString()),
                                          onTap: () {
                                            Get.to(() => DetailAticle(
                                                isVendeur: true,
                                                article: articleModels));
                                          },
                                        ),
                                      ]);
                                }),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            dotWidget,
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CustomText(
                                    data: "Net à payer $netAPayer",
                                    fontSize: 20.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 15.0)
                              ],
                            ),
                            CustomButton(
                              child: "Enregistrer",
                              onPressed: () {
                                locator
                                    .get<ServiceAuth>()
                                    .saveFactureClientData(
                                        vendeur: widget.vendeur,
                                        idBoutique: widget.idBoutique,
                                        telephone: widget.telephone,
                                        nom: widget.nom,
                                        netPayer: netAPayer,
                                        facture: Provider.of<HomeProvider>(
                                                context,
                                                listen: false)
                                            .echoVal,
                                        context: context);
                                // dialogueAjout2(
                                //     context: context,
                                //     child: VerifCodeUser(
                                //         users: locator.get<HomeProvider>().user,
                                //         callBack: (value) {
                                //           if (value) {
                                //             Get.back();
                                //             locator
                                //                 .get<ServiceAuth>()
                                //                 .saveFactureClientData(
                                //                     vendeur: widget.vendeur,
                                //                     idBoutique: widget.idBoutique,
                                //                     telephone: widget.telephone,
                                //                     nom: widget.nom,
                                //                     netPayer: netAPayer,
                                //                     facture:
                                //                         Provider.of<HomeProvider>(
                                //                                 context,
                                //                                 listen: false)
                                //                             .echoVal,
                                //                     context: context);
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
                              color: Colors.white,
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
