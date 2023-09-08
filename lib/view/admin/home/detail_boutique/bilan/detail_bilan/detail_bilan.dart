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
            DataTable(
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
                    data: "Qté",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    data: "Prix",
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
              rows: widget.bilanFactureModel.facture.map(
                (ele) {
                  return DataRow(
                      color: MaterialStateProperty.all(Colors.grey.shade200),
                      cells: [
                        DataCell(
                            CustomText(data: ele.articleModels!.designation!)),
                        DataCell(CustomText(data: ele.quantite.toString())),
                        DataCell(CustomText(data: ele.prixTotal.toString())),
                      ]);
                },
              ).toList(),
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
                      DataCell(
                          CustomText(data: widget.bilanFactureModel.createAt)),
                    ]),
                DataRow(cells: [
                  const DataCell(CustomText(data: "Net Payer")),
                  DataCell(Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      CustomText(
                          data: widget.bilanFactureModel.netPayer.toString()),
                    ],
                  )),
                ]),
              ],
            ),
          ],
        ));
  }
}
