import 'package:ams/models/article_modes.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:ams/view/widgets/check_number.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../../provider/home_provider.dart';
import '../../../../../../services/service_locator.dart';
import '../../../../../../services/services_auth.dart';
import '../../../../../widgets/check_email.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_dialogue_card.dart';
import '../../../../../widgets/custum_text_field.dart';

class AjoutArticle extends StatefulWidget {
  const AjoutArticle({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Row(
                    children: [
                      Expanded(
                        child: CustumTextField(
                            controller: stockActuel,
                            child: 'Stock actuel',
                            keyboardType: TextInputType.number,
                            obscureText: false),
                      ),
                      Expanded(
                        child: CustumTextField(
                            controller: stockNormal,
                            child: 'Stock normal',
                            keyboardType: TextInputType.number,
                            obscureText: false),
                      ),
                    ],
                  ),
                  CustumTextField(
                      controller: stockCritique,
                      child: 'Stock critique',
                      keyboardType: TextInputType.number,
                      obscureText: false),
                  CustumTextField(
                      controller: prixAchat,
                      child: "Prix d'achat",
                      keyboardType: TextInputType.number,
                      obscureText: false),
                  CustumTextField(
                      controller: prixVente,
                      keyboardType: TextInputType.number,
                      child: 'Prix de vente',
                      obscureText: false),
                  const SizedBox(height: 8.0),
                  CustomButton(
                    child: "Enregistrez",
                    onPressed: () {
                      var article = ArticleModels();
                      if (designation.text.isEmpty ||
                          stockActuel.text.isEmpty ||
                          stockNormal.text.isEmpty ||
                          stockCritique.text.isEmpty ||
                          prixAchat.text.isEmpty ||
                          prixVente.text.isEmpty) {
                        //   dialogue(
                        //       panaraDialogType: PanaraDialogType.error,
                        //       message: "Remplissez tous les champs svp!",
                        //       title: "",
                        //       context: context);
                        // } else if (!CheckEmail.isEmail(email.text)) {
                        //   dialogue(
                        //       panaraDialogType: PanaraDialogType.warning,
                        //       message: "Entrez un e-mail valide",
                        //       title: "",
                        //       context: context);
                        // } else if (!CheckPhoneNumber.check(
                        //     telephone.text.toString().trim())) {
                        //   dialogue(
                        //       panaraDialogType: PanaraDialogType.warning,
                        //       message: "Entrez un numero de téléphone valide",
                        //       title: "",
                        //       context: context);
                        // } else {
                        //   // information du vendeur
                        //   var vendeur = Vendeur(
                        //     createAt: DateTime.now().toIso8601String(),
                        //     nom: nom.text.trim(),
                        //     prenom: prenom.text.trim(),
                        //     telephone: telephone.text.trim(),
                        //     email: email.text.trim(),
                        //     grade: "vendeur",
                        //     status: "acif",
                        //     messagingToken: "vide",
                        //     idAdmin: locator.get<HomeProvider>().user.id,
                        //   );

                        //   locator.get<ServiceAuth>().addNewVendeurDataInBoutiques(
                        //       context: context,
                        //       boutiqueModels:
                        //           locator.get<HomeProvider>().boutiqueModels,
                        //       vendeur: vendeur);
                      }
                    },
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
