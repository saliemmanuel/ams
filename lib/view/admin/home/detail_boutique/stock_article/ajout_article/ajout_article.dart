import 'dart:math';

import 'package:ams/models/article_modes.dart';
import 'package:ams/models/boutique_model.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../../services/service_locator.dart';
import '../../../../../../services/services_auth.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_dialogue_card.dart';
import '../../../../../widgets/custom_layout_builder.dart';
import '../../../../../widgets/custum_text_field.dart';

class AjoutArticle extends StatefulWidget {
  final BoutiqueModels boutique;
  const AjoutArticle({super.key, required this.boutique});

  @override
  State<AjoutArticle> createState() => _AjoutArticleState();
}

class _AjoutArticleState extends State<AjoutArticle> {
  var designation = TextEditingController();
  var stockActuel = TextEditingController();
  var stockNormal = TextEditingController();
  var stockCritique = TextEditingController();
  var prixAchat = TextEditingController();
  var prixVente = TextEditingController();
  var prixNonAuto = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var codeEnregistrement = "Produit${Random().nextInt(15500)}";

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
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              data: "Ajoutez un nouveau produit au stock",
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 10.0),
                            CustomText(
                                data:
                                    'Renseignez tous les champs pour ajouter le produit'),
                            SizedBox(height: 10.0),
                          ]),
                    ),
                    CustumTextField(
                        controller: designation,
                        child: 'Désignation',
                        obscureText: false),
                    CustumTextField(
                        controller: prixVente,
                        keyboardType: TextInputType.number,
                        child: 'Prix de vente ',
                        obscureText: false),
                    CustumTextField(
                        controller: prixNonAuto,
                        keyboardType: TextInputType.number,
                        child: 'Prix de vente non autorisé',
                        obscureText: false),
                    Row(
                      children: [
                        Expanded(
                            child: CustumTextField(
                                controller: prixAchat,
                                child: "Prix d'achat",
                                keyboardType: TextInputType.number,
                                obscureText: false)),
                        Expanded(
                          child: CustumTextField(
                              controller: stockActuel,
                              child: 'Stock actuel',
                              keyboardType: TextInputType.number,
                              obscureText: false),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustumTextField(
                              controller: stockNormal,
                              child: 'Stock normal',
                              keyboardType: TextInputType.number,
                              obscureText: false),
                        ),
                        Expanded(
                            child: CustumTextField(
                                controller: stockCritique,
                                child: 'Stock critique',
                                keyboardType: TextInputType.number,
                                obscureText: false)),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    CustomButton(
                      child: "Enregistrez",
                      color: Colors.white,
                      onPressed: () {
                        if (designation.text.isEmpty ||
                            stockActuel.text.isEmpty ||
                            stockNormal.text.isEmpty ||
                            stockCritique.text.isEmpty ||
                            prixAchat.text.isEmpty ||
                            prixVente.text.isEmpty ||
                            prixNonAuto.text.isEmpty) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message: "Remplissez tous les champs svp!",
                              title: "",
                              context: context);
                        } else if (int.tryParse(stockActuel.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Stock actuel doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(stockNormal.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Stock normal doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(stockCritique.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Stock critique doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(prixAchat.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Prix d'achat doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(prixVente.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Prix de vente doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(prixNonAuto.text) == null) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le champ Prix de vente doit être un entier",
                              title: "",
                              context: context);
                        } else if (int.tryParse(stockActuel.text)! <
                            int.tryParse(stockCritique.text)!) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message:
                                  "Le stock actuel doit être suppérieur au stock critique",
                              title: "",
                              context: context);
                        } else {
                          var article = ArticleModels(
                              id: "${locator.get<HomeProvider>().user.id}$codeEnregistrement",
                              idAdmin: locator.get<HomeProvider>().user.id,
                              codeEnregistrement: codeEnregistrement,
                              createAt: DateTime.now().toIso8601String(),
                              designation: designation.text,
                              idBoutique: widget.boutique.id,
                              nomBoutique: widget.boutique.nomBoutique,
                              prixAchat: double.parse(prixAchat.text),
                              prixVente: double.parse(prixVente.text),
                              stockActuel: int.parse(stockActuel.text),
                              stockCritique: int.parse(stockCritique.text),
                              stockNormal: int.parse(stockNormal.text),
                              prixNonAuto: double.parse(prixNonAuto.text));
                          locator.get<ServiceAuth>().saveArticleData(
                              article: article, context: context);
                        }
                      },
                    ),
                    const SizedBox(height: 30.0)
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
