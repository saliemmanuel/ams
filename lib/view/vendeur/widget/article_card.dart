import 'package:ams/models/article_modes.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../../themes/theme.dart';
import '../../widgets/custom_text.dart';

class ListDetailFacture extends StatefulWidget {
  final List<ArticleModels>? listArticleVente;
  const ListDetailFacture({
    super.key,
    this.listArticleVente,
  });

  @override
  State<ListDetailFacture> createState() => _ListDetailFactureState();
}

class _ListDetailFactureState extends State<ListDetailFacture> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.listArticleVente!.length,
      itemBuilder: (context, index) {
        return Container(
          height: 300.0,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        _showToast("Supprimé", position: FlutterToastr.bottom);
                        locator
                            .get<HomeProvider>()
                            .listArticleVente!
                            .remove(widget.listArticleVente![index]);
                        setState(() {});
                      },
                      icon: const Icon(Icons.close, color: Colors.red)),
                  const SizedBox(width: 10.0)
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DataTable(columns: const [
                      DataColumnPlus(
                          label: CustomText(
                              data: 'Nom article',
                              fontWeight: FontWeight.bold)),
                      DataColumn(
                          label: CustomText(
                              data: 'Prix Unit.', fontWeight: FontWeight.bold)),
                    ], rows: [
                      DataRow(cells: [
                        DataCell(CustomText(
                            data:
                                widget.listArticleVente![index].designation!)),
                        DataCell(CustomText(
                            data: widget.listArticleVente![index].prixVente
                                .toString())),
                      ])
                    ]),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              PrixEtQuantite(
                index: index,
                listArticleVente: widget.listArticleVente!,
              )
            ],
          ),
        );
      },
    );
  }

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }
}

class PrixEtQuantite extends StatefulWidget {
  final List<ArticleModels>? listArticleVente;
  final int index;

  const PrixEtQuantite({super.key, this.listArticleVente, required this.index});

  @override
  State<PrixEtQuantite> createState() => _PrixEtQuantiteState();
}

class _PrixEtQuantiteState extends State<PrixEtQuantite> {
  var controller = TextEditingController(text: "1");
  late double prixTotal;

  @override
  void initState() {
    prixTotal = widget.listArticleVente![widget.index].prixVente! *
        int.parse(controller.text.isEmpty ? "0" : controller.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DataTable(columns: const [
            DataColumn(
                label: CustomText(data: 'Qté', fontWeight: FontWeight.bold)),
            DataColumn(
                label: CustomText(
                    data: 'Prix Total', fontWeight: FontWeight.bold)),
          ], rows: [
            DataRow(cells: [
              DataCell(Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      prixTotal = widget
                              .listArticleVente![widget.index].prixVente! *
                          int.parse(
                              controller.text.isEmpty ? "0" : controller.text);

                      locator.get<HomeProvider>().calculPrixTotal(prixTotal);
                      setState(() {});
                    },
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Palette.primary)),
                    ),
                  )),
                ],
              )),
              DataCell(CustomText(data: prixTotal.toString())),
            ])
          ]),
        ),
      ],
    );
  }
}
