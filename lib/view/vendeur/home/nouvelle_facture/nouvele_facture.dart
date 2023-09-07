import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:iconly/iconly.dart';

import '../../../../models/article_modes.dart';
import '../../../../themes/theme.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custum_text_field.dart';
import '../../widget/article_card.dart';

class NouvelleFacture extends StatefulWidget {
  final List<ArticleModels>? listArticleVente;
  const NouvelleFacture({super.key, this.listArticleVente});

  @override
  State<NouvelleFacture> createState() => NouvelleFactureState();
}

class NouvelleFactureState extends State<NouvelleFacture> {
  var nom = TextEditingController();
  var telephone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(data: "Nouvelle Facture"),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      data: "Information du client",
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          child: CustumTextField(
                              controller: nom,
                              prefixIcon: IconlyBold.profile,
                              keyboardType: TextInputType.emailAddress,
                              child: 'Nom client',
                              obscureText: false),
                        ),
                        Expanded(
                          child: CustumTextField(
                              controller: telephone,
                              prefixIcon: IconlyBold.call,
                              keyboardType: TextInputType.number,
                              child: 'Téléphone',
                              obscureText: false),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    const CustomText(
                      data: "liste commande",
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              ListDetailFacture(listArticleVente: widget.listArticleVente!),
              const SizedBox(height: 160.0)
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DataTable(columns: const [
                  DataColumn(
                      label: Center(
                    child: CustomText(
                        data: "Prix total", fontWeight: FontWeight.bold),
                  )),
                ], rows: const [
                  DataRow(cells: [
                    DataCell(CustomText(data: "100")),
                  ])
                ]),
              ),
              FilledButton.tonalIcon(
                label: const CustomText(data: "Termier"),
                onPressed: () {},
                icon: const Icon(Icons.save),
              )
            ],
          )
        ]);
  }

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }

  buildData({required int index}) {
    double prixTotal = 0.0;
    var quantite = TextEditingController(text: "1");

    return DataRow(
        color: index % 2 != 0
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(Colors.grey.shade200),
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(
              CustomText(data: widget.listArticleVente![index].designation!)),
          DataCell(CustomText(
              data: widget.listArticleVente![index].prixVente!.toString())),
          DataCell(Row(
            children: [
              Expanded(
                  child: TextField(
                controller: quantite,
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
          DataCell(IconButton(
              onPressed: () {
                _showToast("Supprimé", position: FlutterToastr.bottom);
                locator
                    .get<HomeProvider>()
                    .listArticleVente!
                    .remove(widget.listArticleVente![index]);
                setState(() {});
              },
              icon: const Icon(Icons.delete, color: Colors.red)))
        ]);
  }
}
