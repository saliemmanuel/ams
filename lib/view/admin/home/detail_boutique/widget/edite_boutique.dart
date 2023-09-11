import 'package:ams/models/boutique_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../services/service_locator.dart';
import '../../../../../services/services_auth.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dialogue_card.dart';
import '../../../../widgets/custum_text_field.dart';

class EditeBoutique extends StatefulWidget {
  final BoutiqueModels boutiqueModels;

  const EditeBoutique({
    super.key,
    required this.boutiqueModels,
  });

  @override
  State<EditeBoutique> createState() => _EditeBoutiqueState();
}

class _EditeBoutiqueState extends State<EditeBoutique> {
  TextEditingController? nom;
  @override
  void initState() {
    nom = TextEditingController(text: widget.boutiqueModels.nomBoutique);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
              CustumTextField(
                  keyboardType: TextInputType.text,
                  controller: nom,
                  child: "Nouveau nom ",
                  obscureText: false),
              const SizedBox(height: 8.0),
              CustomButton(
                  child: "Enregistrez",
                  color: Colors.white,
                  onPressed: () {
                    if (nom!.text.isEmpty) {
                      dialogue(
                          panaraDialogType: PanaraDialogType.error,
                          message: "Entrez un nom svp",
                          title: "",
                          context: context);
                    } else {
                      locator.get<ServiceAuth>().editNomBoutique(
                          context: context,
                          nouveauNom: nom!.text,
                          boutiqueModels: widget.boutiqueModels);
                    }
                  }),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
