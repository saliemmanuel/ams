import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'package:ams/models/user.dart';

import '../../services/service_locator.dart';
import '../../services/services_auth.dart';
import 'custom_button.dart';
import 'custom_dialogue_card.dart';
import 'custum_text_field.dart';

class EditeProfil extends StatefulWidget {
  final Users users;

  const EditeProfil({
    super.key,
    required this.users,
  });

  @override
  State<EditeProfil> createState() => _EditeProfilState();
}

class _EditeProfilState extends State<EditeProfil> {
  TextEditingController? nomController;
  TextEditingController? prenomController;
  @override
  void initState() {
    prenomController = TextEditingController(text: widget.users.prenom);
    nomController = TextEditingController(text: widget.users.nom);
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
                  controller: nomController,
                  child: "Nom",
                  obscureText: false),
              CustumTextField(
                  keyboardType: TextInputType.text,
                  controller: prenomController,
                  child: "Prénom",
                  obscureText: false),
              const SizedBox(height: 8.0),
              CustomButton(
                  child: "Enregistrez",
                  color: Colors.white,
                  onPressed: () {
                    if (nomController!.text.isEmpty) {
                      dialogue(
                          panaraDialogType: PanaraDialogType.error,
                          message: "Entrez un nom svp",
                          title: "",
                          context: context);
                    } else {
                      locator.get<ServiceAuth>().editUsersNomAndPrenom(
                          context: context,
                          users: widget.users,
                          nom: nomController!.text,
                          prenom: prenomController!.text);
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
