import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/services_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';

import '../../../../services/service_locator.dart';
import '../../../widgets/custom_dialogue_card.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custum_text_field.dart';
import '../../widget/article_card.dart';

class NouvelleFacture extends StatefulWidget {
  const NouvelleFacture({
    super.key,
  });

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.tonalIcon(
                        label: const CustomText(data: "Tous éffacer"),
                        onPressed: () {
                          if (!Provider.of<HomeProvider>(context, listen: false)
                              .listArticleVente!
                              .isNotEmpty) {
                            locator.get<ServiceAuth>().showToast(
                                context: context,
                                "Vide",
                                position: FlutterToastr.bottom);
                          } else {
                            dialogueAndonTapDismissCustomButtonText(
                                cancelButtonText: "Annuler",
                                confirmButtonText: "Supprimer",
                                onTapCancel: () {
                                  Get.back();
                                },
                                onTapConfirm: () {
                                  Get.back();
                                  Provider.of<HomeProvider>(context,
                                          listen: false)
                                      .remoceAllValeurArticleVente();
                                  setState(() {});
                                },
                                panaraDialogType: PanaraDialogType.error,
                                message:
                                    "Vous voulez vraiment éffacer toute la facture? ",
                                context: context);
                          }
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // ici j'affiche les listes des articles selectionner
            const ListDetailFacture(),
            const SizedBox(height: 160.0)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.tonalIcon(
        label: const CustomText(data: "Termier"),
        onPressed: () {
          if (!Provider.of<HomeProvider>(context, listen: false)
              .listArticleVente!
              .isNotEmpty) {
            locator.get<ServiceAuth>().showToast(
                context: context,
                "Aucun article dans la facture",
                position: FlutterToastr.bottom);
          }
          print(Provider.of<HomeProvider>(context, listen: false).echoVal.first.quantite);
        },
        icon: const Icon(Icons.save_outlined),
      ),
    );
  }
}
