import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/facture_client_model.dart';
import 'package:ams/services/services_auth.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../../themes/theme.dart';
import '../../widgets/custom_text.dart';

class ListDetailFacture extends StatefulWidget {
  final BoutiqueModels boutiqueModels;
  const ListDetailFacture({super.key, required this.boutiqueModels});

  @override
  State<ListDetailFacture> createState() => _ListDetailFactureState();
}

class _ListDetailFactureState extends State<ListDetailFacture> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          physics: const PageScrollPhysics(),
          shrinkWrap: true,
          itemCount: value.listArticleVente!.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DataTable(columns: const [
                          DataColumnPlus(
                              label: CustomText(
                                  data: 'Nom', fontWeight: FontWeight.bold)),
                          DataColumn(
                            label: CustomText(
                                data: 'Prix U.',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                          ),
                          DataColumn(
                              label: CustomText(
                                  data: 'Stock A.',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold))
                        ], rows: [
                          DataRow(cells: [
                            DataCell(CustomText(
                                data: value
                                    .listArticleVente![index].designation!)),
                            DataCell(CustomText(
                                data: value.listArticleVente![index].prixVente
                                    .toString())),
                            DataCell(CustomText(
                                data: value.listArticleVente![index].stockActuel
                                    .toString())),
                          ])
                        ]),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2),
                  PrixEtQuantite(
                    index: index,
                    listArticleVente: value.listArticleVente!,
                    boutiqueModels: widget.boutiqueModels,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PrixEtQuantite extends StatefulWidget {
  final List<ArticleModels>? listArticleVente;
  final BoutiqueModels boutiqueModels;

  final int index;

  const PrixEtQuantite(
      {super.key,
      required this.index,
      required this.listArticleVente,
      required this.boutiqueModels});

  @override
  State<PrixEtQuantite> createState() => _PrixEtQuantiteState();
}

class _PrixEtQuantiteState extends State<PrixEtQuantite> {
  // J'initie la quantité d'article à 1
  var controller = TextEditingController(text: "1");

  // pour le calcule du prix total des articles du clients
  late double prixTotal;
  String date = DateTime.now().toIso8601String();
  @override
  void initState() {
    // je commmence par initier le prix total (
    // elle se calcule comme suit prixVente * Qté)
    // donc je peut l'aisser ça égale au prixVente
    prixTotal = widget.listArticleVente![widget.index].prixVente!;
    initCustomval();
    super.initState();
  }

  initCustomval() async {
    Future.delayed(Duration.zero, () {
      // je recupère de la liste des articles chaque pour faire la facture
      var facture = FactureClient.fromMap({
        "index": widget.index,
        "prixTotal": prixTotal,
        "quantite": int.parse(controller.text),
        "articleModels": widget.listArticleVente![widget.index].toMap(),
        "createAt": date,
        "idBoutique": widget.boutiqueModels.id
      });
      // et je l'insère dans la liste globale de facture
      // echoVal dans HomeProvider est une List<FactureClient>
      // setEchoVal(FactureClient facture){
      //    echoVal.add(facture);
      // }
      Provider.of<HomeProvider>(context, listen: false).setEchoVal(facture);
    });
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
                label:
                    CustomText(data: 'Prix T.', fontWeight: FontWeight.bold)),
            DataColumn(
                label: CustomText(data: 'Supp.', fontWeight: FontWeight.bold)),
          ], rows: [
            DataRow(cells: [
              DataCell(Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      // Je verifie si le vendeur entre une Qté qui n'est pas suppérieur au stock actuell
                      if (int.parse(controller.text.isEmpty
                              ? "1"
                              : controller.text) >=
                          widget.listArticleVente![widget.index].stockActuel!) {
                        // Si oui je lui renvoi un message
                        locator.get<ServiceAuth>().showToast(
                            context: context,
                            "Overflow stock",
                            position: FlutterToastr.bottom);
                        controller.text = widget
                            .listArticleVente![widget.index].stockActuel!
                            .toString();
                      } else {
                        // si non je recalcule le prix vente par rapport à la Qté qu'il as renseigné
                        calcPrixVente();
                      }
                    },
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Palette.primary)),
                    ),
                  )),
                  Column(
                    children: [
                      InkWell(
                        child: const Icon(Icons.add),
                        onTap: () {
                          // je verifie quand le vendeur increment il ne doit pas dépasser la Qté actuelle disponible
                          if (int.parse(controller.text.isEmpty
                                  ? "1"
                                  : controller.text) >=
                              widget.listArticleVente![widget.index]
                                  .stockActuel!) {
                            // s'il le depasse, il as un message
                            locator.get<ServiceAuth>().showToast(
                                context: context,
                                "Overflow stock",
                                position: FlutterToastr.bottom);
                          } else {
                            // s'il ne depasse j'incrémente cette valeur
                            var increment = int.parse(controller.text.isEmpty
                                    ? "1"
                                    : controller.text) +
                                1;
                            controller.text = increment.toString();
                            // et je refait les calcules
                            calcPrixVente();
                          }
                        },
                      ),
                      InkWell(
                        child: const Icon(Icons.remove),
                        onTap: () {
                          // je décrement la Qté
                          var decrement = int.parse(controller.text.isEmpty
                                  ? "1"
                                  : controller.text) -
                              1;
                          //
                          if (decrement >= 1) {
                            controller.text = decrement.toString();
                          }
                          calcPrixVente();
                        },
                      )
                    ],
                  )
                ],
              )),
              DataCell(CustomText(data: prixTotal.toString())),
              DataCell(IconButton(
                  onPressed: () {
                    // ici je supprime de la liste des articles de la liste globale des articles
                    Provider.of<HomeProvider>(context, listen: false)
                        .remoceValeurArticleVente(
                            widget.listArticleVente![widget.index]);
                    // je parcours la liste globale de facture, et je remove par rapport à l'index
                    Provider.of<HomeProvider>(context, listen: false)
                        .removeWhereListArticleVente((element) {
                      return element.index == widget.index;
                    });
                    locator.get<ServiceAuth>().showToast(
                        context: context,
                        "Supprimé",
                        position: FlutterToastr.bottom);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete, color: Colors.red))),
            ])
          ]),
        ),
      ],
    );
  }

  calcPrixVente() {
    prixTotal = widget.listArticleVente![widget.index].prixVente! *
        int.parse(controller.text.isEmpty ? "1" : controller.text);

    // je dois update la Qté et le prixTotal
    // de la liste globale des facture

    // remove la facture de la liste globale des factures, je remplace avec sa nouvelle valeur
    // je prépare la nouvelle valeur de la facture
    var facture = FactureClient.fromMap({
      "index": widget.index,
      "prixTotal": prixTotal,
      "quantite": int.parse(controller.text),
      "articleModels": widget.listArticleVente![widget.index].toMap(),
      "createAt": date,
      "idBoutique": widget.boutiqueModels.id
    });
    // je la remove
    Provider.of<HomeProvider>(context, listen: false)
        .removeWhereListArticleVente((element) {
      return element.index == facture.index;
    });
    // je la remplace
    Provider.of<HomeProvider>(context, listen: false).setEchoVal(facture);
    setState(() {});
  }
}
