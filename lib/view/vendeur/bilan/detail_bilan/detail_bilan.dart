import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/service_locator.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/bilan_facture_model.dart';
import '../../../widgets/custom_layout_builder.dart';
import '../../../widgets/custom_text.dart';

class DetailBilanVendeux extends StatefulWidget {
  final BilanFactureModel bilanFactureModel;

  const DetailBilanVendeux({super.key, required this.bilanFactureModel});

  @override
  State<DetailBilanVendeux> createState() => _DetailBilanVendeuxState();
}

class _DetailBilanVendeuxState extends State<DetailBilanVendeux> {
  var beneficeT = 0.0;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
          appBar: AppBar(
            title: const CustomText(data: "Détail facture"),
            actions: [
              Consumer<HomeProvider>(builder: (context, value, child) {
                return FilledButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green)),
                  child: const Icon(Icons.print),
                  onPressed: () {
                    value.printPdfSinglePage(widget.bilanFactureModel, false);
                  },
                );
              }),
              const SizedBox(width: 10.0),
            ],
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
                          data: "Qté",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataColumn(
                        label: CustomText(
                          data: "Remise",
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
                            color:
                                MaterialStateProperty.all(Colors.grey.shade200),
                            cells: [
                              DataCell(CustomText(
                                  data: ele.articleModels!.designation!)),
                              DataCell(CustomText(
                                  data:
                                      ele.articleModels!.prixVente.toString())),
                              DataCell(
                                  CustomText(data: ele.quantite.toString())),
                              DataCell(CustomText(data: ele.remise.toString())),
                              DataCell(
                                  CustomText(data: ele.prixTotal.toString())),
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
                      data: "",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                      color: MaterialStateProperty.all(Colors.grey.shade200),
                      cells: [
                        const DataCell(CustomText(data: "Date")),
                        DataCell(CustomText(
                          data: locator.get<HomeProvider>().formatDate(
                              date: widget.bilanFactureModel.createAt),
                        )),
                      ]),
                ],
              ),
            ],
          )),
    );
  }
}
