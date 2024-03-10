import 'package:ams/models/article_model.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/facture_client_model.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/formate_date.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../../themes/theme.dart';
import '../../widgets/custom_layout_builder.dart';
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
    return CustomLayoutBuilder(
      child: Consumer<HomeProvider>(
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 8.0,
                      right: 10.0,
                      child: IconButton(
                          onPressed: () {
                            // ici je supprime de la liste des articles de la liste globale des articles
                            Provider.of<HomeProvider>(context, listen: false)
                                .remoceValeurArticleVente(
                                    value.listArticleVente![index]);
                            // je parcours la liste globale de facture, et je remove par rapport à l'index
                            Provider.of<HomeProvider>(context, listen: false)
                                .removeWhereListArticleVente((element) {
                              return element.index == index;
                            });
                            locator.get<ServiceAuth>().showToast(
                                context: context,
                                "Supprimé",
                                position: FlutterToastr.bottom);

                            HapticFeedback.mediumImpact();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close, color: Colors.red)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                  text: value
                                      .listArticleVente![index].designation!,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                          const Divider(),
                          const SizedBox(height: 10.0),
                          Text.rich(TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Stock Actuel  : ',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: value
                                      .listArticleVente![index].stockActuel
                                      .toString(),
                                  style: const TextStyle(fontSize: 18.0)),
                            ],
                          )),
                          const Divider(thickness: 2),
                          PrixEtQuantite(
                            index: index,
                            listArticleVente: value.listArticleVente!,
                            boutiqueModels: widget.boutiqueModels,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ce widget est la pour les line intérrompu
  Widget dotWidget = Container(
    decoration:
        DottedDecoration(shape: Shape.line, linePosition: LinePosition.bottom),
    width: double.infinity,
  );
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
  var quantite = TextEditingController(text: "1");
  // je créer un crontroller pour le Prix de vente
  // Qui peut être modifer par le vendeur
  // Mais controler, cette valeur ne doit pas être inférieur au prix non autorisé
  // late TextEditingController? prixVente;
  var remise = TextEditingController(text: "0");

  // pour le calcule du prix total des articles du clients
  late double prixTotal;
  String date = DateTime.now().toString();
  @override
  void initState() {
    // je commmence par initier le prix total
    // elle se calcule comme suit prixVente * Qté
    // donc je peut l'aisser ça égale au prixVente
    // Comme la quantité est de 1

    prixTotal = double.parse(
        widget.listArticleVente![widget.index].prixVente!.toString());

    initCustomval();
    super.initState();
  }

  initCustomval() async {
    Future.delayed(Duration.zero, () {
      // je recupère de la liste des articles chaque pour faire la facture
      var facture = FactureClient.fromMap({
        "index": widget.index,
        "prixTotal": prixTotal,
        "quantite": int.parse(quantite.text),
        "articleModels": widget.listArticleVente![widget.index].toMap(),
        "createAt": formatDate(date: date, enableHour: false),
        "remise": (double.parse(remise.text.isEmpty ? "0" : remise.text)),
        "idBoutique": widget.boutiqueModels.id
      });
      // prixVente = TextEditingController(
      //     text: facture.articleModels!.prixVente.toString());

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Text.rich(TextSpan(
          children: [
            const TextSpan(
                text: 'Prix Non Auto.  : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            TextSpan(
                text: widget.listArticleVente![widget.index].prixNonAuto
                    .toString(),
                style: TextStyle(
                    fontSize: 18.0,
                    color: widget.listArticleVente![widget.index].prixNonAuto! *
                                int.parse(quantite.text.isEmpty
                                    ? "1"
                                    : quantite.text) >
                            prixTotal
                        ? Colors.red
                        : null)),
          ],
        )),
        const Divider(),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const CustomText(
                data: 'Quantité  : ',
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    height: 55.0,
                    child: TextField(
                      onChanged: (value) {
                        // Je verifie si le vendeur entre une Qté qui n'est pas suppérieur au stock actuell
                        if (int.parse(
                                quantite.text.isEmpty ? "1" : quantite.text) >=
                            widget
                                .listArticleVente![widget.index].stockActuel!) {
                          // Si oui je lui renvoi un message
                          locator.get<ServiceAuth>().showToast(
                              context: context,
                              "Overflow stock",
                              position: FlutterToastr.bottom);
                          quantite.text = widget
                              .listArticleVente![widget.index].stockActuel!
                              .toString();
                        } else if (value == "0") {
                          quantite.text = "1";
                        } else {
                          // si non je recalcule le prix vente par rapport à la Qté qu'il as renseigné
                          calcPrixVente();
                        }
                        HapticFeedback.mediumImpact();
                      },
                      controller: quantite,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Palette.primary)),
                      ),
                    ),
                  )),
                  Column(
                    children: [
                      InkWell(
                        child: const Icon(Icons.add),
                        onTap: () {
                          HapticFeedback.mediumImpact();

                          /// je verifie quand le vendeur increment il ne doit
                          /// pas dépasser la Qté actuelle disponible
                          if (int.parse(quantite.text.isEmpty
                                  ? "1"
                                  : quantite.text) >=
                              widget.listArticleVente![widget.index]
                                  .stockActuel!) {
                            // s'il le depasse, il as un message
                            locator.get<ServiceAuth>().showToast(
                                context: context,
                                "Overflow stock",
                                position: FlutterToastr.bottom);
                          } else {
                            // s'il ne depasse j'incrémente cette valeur
                            var increment = int.parse(quantite.text.isEmpty
                                    ? "1"
                                    : quantite.text) +
                                1;
                            quantite.text = increment.toString();
                            // et je refait les calcules
                            calcPrixVente();
                          }
                        },
                      ),
                      InkWell(
                        child: const Icon(Icons.remove),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          // je décrement la Qté
                          var decrement = int.parse(
                                  quantite.text.isEmpty ? "1" : quantite.text) -
                              1;
                          //
                          if (decrement >= 1) {
                            quantite.text = decrement.toString();
                          }
                          calcPrixVente();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 18.0),
        Text.rich(TextSpan(
          children: [
            const TextSpan(
                text: '  Prix U.   : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    widget.listArticleVente![widget.index].prixVente.toString(),
                style: const TextStyle(
                  fontSize: 18.0,
                )),
          ],
        )),
        const Divider(),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const CustomText(
                data: 'Remise:  ', fontSize: 18.0, fontWeight: FontWeight.bold),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    height: 55.0,
                    child: TextField(
                      controller: remise,
                      onChanged: (value) {
                        HapticFeedback.mediumImpact();
                        print(widget.listArticleVente![widget.index]
                                    .prixNonAuto! *
                                int.parse(quantite.text.isEmpty
                                    ? "1"
                                    : quantite.text) >
                            prixTotal);
                        calcPrixVente();
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Palette.primary)),
                      ),
                    ),
                  )),
                  const SizedBox(width: 22.0)
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        // ignore: prefer_const_constructors
        Visibility(
          visible: widget.listArticleVente![widget.index].prixNonAuto! *
                  int.parse(quantite.text.isEmpty ? "1" : quantite.text) >
              prixTotal,
          child: const CustomText(
              data: "Vous ne pouvez pas vendre à ce prix", color: Colors.red),
        ),
        const Divider(),
        const SizedBox(height: 10.0),
        Text.rich(TextSpan(
          children: [
            const TextSpan(
                text: 'Prix T. : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            TextSpan(
                text: prixTotal.toString(),
                style: const TextStyle(fontSize: 18.0)),
          ],
        )),
      ],
    );
  }

  calcPrixVente() {
    prixTotal = ((double.parse(
                widget.listArticleVente![widget.index].prixVente.toString()) *
            int.parse(quantite.text.isEmpty ? "1" : quantite.text)) -
        (double.parse(remise.text.isEmpty ? "0" : remise.text) *
            int.parse(quantite.text.isEmpty ? "1" : quantite.text)));

    // je dois update la Qté et le prixTotal
    // de la liste globale des facture

    // remove la facture de la liste globale des factures, je remplace avec sa nouvelle valeur
    // je prépare la nouvelle valeur de la facture
    var facture = FactureClient.fromMap({
      "index": widget.index,
      "prixTotal": prixTotal,
      "quantite": int.parse(quantite.text.isEmpty ? "1" : quantite.text),
      "articleModels": widget.listArticleVente![widget.index].toMap(),
      "createAt": formatDate(date: date, enableHour: false),
      "remise": (double.parse(remise.text.isEmpty ? "0" : remise.text) *
          int.parse(quantite.text.isEmpty ? "1" : quantite.text)),
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
