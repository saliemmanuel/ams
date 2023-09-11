import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:ams/models/user.dart';
import 'package:new_pinput/new_pinput.dart';

import 'custom_button.dart';

enum codeStatut { creation, modification, verification }

class CodeUser extends StatefulWidget {
  final Users users;
  final codeStatut statut;

  final String? label;

  const CodeUser({
    super.key,
    required this.users,
    required this.label,
    required this.statut,
  });

  @override
  State<CodeUser> createState() => _CodeUserState();
}

class _CodeUserState extends State<CodeUser> {
  var code = TextEditingController();

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
              const Align(
                alignment: Alignment.bottomLeft,
                child: CustomText(
                  data: "  Entrez code secret",
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Pinput(
                length: 4,
                obscureText: true,
                controller: code,
                autofocus: true,
                obscuringCharacter: "#",
                onCompleted: (pin) {
                  if (widget.statut == codeStatut.creation) {
                    print("creation");
                    locator.get<ServiceAuth>().getCreateUserCode(
                        users: widget.users, code: code.text);
                  } else if (widget.statut == codeStatut.modification) {
                    print("modificaiton");
                  } else if (widget.statut == codeStatut.verification) {
                    print("verification");
                  }
                },
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                  child: "Validez",
                  color: Colors.white,
                  onPressed: () {
                    
                    // if (nomController!.text.isEmpty) {
                    //   dialogue(
                    //       panaraDialogType: PanaraDialogType.error,
                    //       message: "Entrez un nom svp",
                    //       title: "",
                    //       context: context);
                    // } else {
                    //   locator.get<ServiceAuth>().editUsersNomAndPrenom(
                    //       context: context,
                    //       users: widget.users,
                    //       nom: nomController!.text,
                    //       prenom: prenomController!.text);
                    // }
                  }),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
