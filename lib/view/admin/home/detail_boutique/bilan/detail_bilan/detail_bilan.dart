import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/service_locator.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../../models/bilan_facture_model.dart';
import '../../../../../widgets/custom_text.dart';

class DetailBilan extends StatefulWidget {
  final BilanFactureModel bilanFactureModel;

  const DetailBilan({super.key, required this.bilanFactureModel});

  @override
  State<DetailBilan> createState() => _DetailBilanState();
}

class _DetailBilanState extends State<DetailBilan> {
  var beneficeT = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Détail facture"),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
                height: 150.0, child: Icon(IconlyBold.image_2, size: 120.0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    data: widget.bilanFactureModel.nom,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                CustomText(
                    data: widget.bilanFactureModel.telephone,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ],
            ),
            Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                child: DataTablePlus(
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
                        data: "Prix V.",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DataColumn(
                      label: CustomText(
                        data: "Prix A.",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DataColumn(
                      label: CustomText(
                        data: "Qté",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DataColumn(
                      label: CustomText(
                        data: "Béné./Articl.",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DataColumn(
                      label: CustomText(
                        data: "Prix T./Articl.",
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                  rows: widget.bilanFactureModel.facture.map(
                    (ele) {
                      beneficeT += ((ele.articleModels!.prixVente! -
                              ele.articleModels!.prixAchat!) *
                          ele.quantite!);
                      return DataRow(
                          color: MaterialStateProperty.all(Colors.grey.shade200),
                          cells: [
                            DataCell(CustomText(
                                data: ele.articleModels!.designation!)),
                            DataCell(CustomText(
                                data: ele.articleModels!.prixVente.toString())),
                            DataCell(CustomText(
                                data: ele.articleModels!.prixAchat.toString())),
                            DataCell(CustomText(data: ele.quantite.toString())),
                            DataCell(CustomText(
                                data: ((ele.articleModels!.prixVente! -
                                            ele.articleModels!.prixAchat!) *
                                        ele.quantite!)
                                    .toString())),
                            DataCell(CustomText(data: ele.prixTotal.toString())),
                          ]);
                    },
                  ).toList(),
                ),
              ),
            ),
            DataTable(
              showBottomBorder: true,
              columns: const [
                DataColumn(
                  label: CustomText(
                    data: "",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    data: " ",
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
              rows: [
                DataRow(
                    color: MaterialStateProperty.all(Colors.grey.shade200),
                    cells: [
                      const DataCell(CustomText(data: "Date")),
                      DataCell(CustomText(
                        data: locator.get<HomeProvider>().formatDate(date: widget.bilanFactureModel.createAt),
                      )),
                    ]),
                DataRow(cells: [
                  const DataCell(Row(
                    children: [
                      CustomText(data: "Net Payer  "),
                      Icon(Icons.check_circle_outline, color: Colors.green),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      CustomText(
                          data: widget.bilanFactureModel.netPayer.toString()),
                    ],
                  )),
                ]),
                DataRow(
                    color: MaterialStateProperty.all(Colors.grey.shade200),
                    cells: [
                      const DataCell(Row(
                        children: [
                          CustomText(data: "Bénéfice    "),
                          Icon(Icons.monetization_on_outlined,
                              color: Colors.green),
                        ],
                      )),
                      DataCell(Row(
                        children: [
                          CustomText(data: beneficeT.toString()),
                        ],
                      )),
                    ]),
              ],
            ),
          ],
        ));
  }
}
