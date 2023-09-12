import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/view/admin/widget/dialogue_ajout.dart';
import 'package:ams/view/widgets/custom_dialogue_card.dart';
import 'package:ams/view/widgets/verif_code_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/services_auth.dart';
import '../../widgets/custom_text.dart';

class VendeurCard extends StatelessWidget {
  final Vendeur? vendeur;
  final BoutiqueModels boutiqueModels;
  final void Function()? onTap;
  const VendeurCard(
      {super.key, this.vendeur, this.onTap, required this.boutiqueModels});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Image.asset('assets/images/vendeur.png'),
          title: CustomText(
            data: "${vendeur!.nom!} ${vendeur!.prenom!}",
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
          trailing: IconButton(
            icon: const Icon(IconlyBold.delete, color: Colors.red),
            onPressed: () {
              confirmDialogue(
                  panaraDialogType: PanaraDialogType.error,
                  title: "Suppression",
                  message: "Voulez-vous vraiment supprimer ce vendeur?",
                  context: context,
                  onTapConfirm: () {
                    Get.back();
                    dialogueAjout2(
                        context: context,
                        child: VerifCodeUser(
                          callBack: (value) {
                            if (value) {
                              Get.back();
                              locator.get<ServiceAuth>().deleteVendeur(
                                  context: context, vendeurId: vendeur!.id);
                              locator.get<ServiceAuth>().showToast("Supprimé",
                                  context: context,
                                  position: FlutterToastr.bottom);
                            } else {
                              dialogueAndonTapDismiss(
                                  onTapDismiss: () {
                                    Get.back();
                                  },
                                  panaraDialogType: PanaraDialogType.error,
                                  message: "Code secret incorrect",
                                  title: "",
                                  context: context);
                            }
                          },
                          users: locator.get<HomeProvider>().user,
                        ));
                  });
            },
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(data: vendeur!.grade!, fontWeight: FontWeight.bold),
              InkWell(
                  onTap: () {
                    _launchUrl(
                        url:
                            "mailto:${vendeur!.email!}?subject=AMS&body=Ecrivez le corps ici");
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                            overflow: TextOverflow.ellipsis,
                            data: vendeur!.email!,
                            color: Colors.blue),
                      ),
                    ],
                  )),
              InkWell(
                  onTap: () {
                    _launchUrl(url: "tel:${vendeur!.telephone!}");
                  },
                  child: CustomText(
                      data: vendeur!.telephone!, color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl({String? url}) async {
    if (!await launchUrl(Uri.parse(url!))) {
      throw Exception('Could not launch $url');
    }
  }
}
