import 'package:ams/models/vendeur_model.dart';
import 'package:ams/view/widgets/check_number.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../provider/home_provider.dart';
import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/check_email.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dialogue_card.dart';
import '../../../../widgets/custom_layout_builder.dart';
import '../../../../widgets/custum_text_field.dart';

class AjoutVendeur extends StatefulWidget {
  const AjoutVendeur({super.key});

  @override
  State<AjoutVendeur> createState() => _AjoutVendeurState();
}

class _AjoutVendeurState extends State<AjoutVendeur> {
  var nom = TextEditingController();
  var prenom = TextEditingController();
  var email = TextEditingController();
  var telephone = TextEditingController();
  var mdp = TextEditingController();
  var controller = PageController();
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
                              data: "Créer un compte vendeur",
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 10.0),
                            CustomText(
                                data:
                                    'Renseignez tous les champs pour créer un compte\nCe vendeur serai associer à cette boutique'),
                            SizedBox(height: 10.0),
                          ]),
                    ),
                    CustumTextField(
                        controller: nom,
                        prefixIcon: IconlyBold.profile,
                        child: 'Nom',
                        obscureText: false),
                    CustumTextField(
                        controller: prenom,
                        prefixIcon: IconlyBold.profile,
                        child: 'Prénom',
                        obscureText: false),
                    CustumTextField(
                        controller: telephone,
                        prefixIcon: IconlyBold.call,
                        keyboardType: TextInputType.number,
                        child: 'Telephone',
                        obscureText: false),
                    CustumTextField(
                        controller: email,
                        prefixIcon: IconlyBold.message,
                        child: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false),
                    const SizedBox(height: 8.0),
                    CustomButton(
                      child: "Enregistrez",
                      onPressed: () {
                        if (nom.text.isEmpty ||
                            prenom.text.isEmpty ||
                            telephone.text.isEmpty ||
                            email.text.isEmpty) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.error,
                              message: "Remplissez tous les champs svp!",
                              title: "",
                              context: context);
                        } else if (!CheckEmail.isEmail(email.text)) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.warning,
                              message: "Entrez un e-mail valide",
                              title: "",
                              context: context);
                        } else if (!CheckPhoneNumber.check(
                            telephone.text.toString().trim())) {
                          dialogue(
                              panaraDialogType: PanaraDialogType.warning,
                              message: "Entrez un numero de téléphone valide",
                              title: "",
                              context: context);
                        } else {
                          // information du vendeur
                          var vendeur = Vendeur(
                            createAt: DateTime.now().toIso8601String(),
                            nom: nom.text.trim(),
                            prenom: prenom.text.trim(),
                            telephone: telephone.text.trim(),
                            email: email.text.trim(),
                            grade: "vendeur",
                            status: "acif",
                            messagingToken: "vide",
                            idAdmin: locator.get<HomeProvider>().user.id,
                          );
    
                          locator.get<ServiceAuth>().addNewVendeurDataInBoutiques(
                              context: context,
                              boutiqueModels:
                                  locator.get<HomeProvider>().boutiqueModels,
                              vendeur: vendeur);
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
      ),
    );
  }
}
