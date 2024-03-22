import 'package:ams/view/widgets/check_email.dart';
import 'package:ams/view/widgets/custom_button.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:ams/view/widgets/custum_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../models/user.dart';
import '../../services/service_locator.dart';
import '../../services/services_auth.dart';
import '../widgets/custom_layout_builder.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var nom = TextEditingController();
  var prenom = TextEditingController();
  var email = TextEditingController();
  var telephone = TextEditingController();
  var mdp = TextEditingController();
  var grade = "Type compte";
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          data: "Créer un compte",
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 10.0),
                        CustomText(
                            data:
                                'Renseignez tous les champs pour créer un compte'),
                        SizedBox(height: 15.0),
                      ]),
                ),
                CustumTextField(
                    controller: nom,
                    prefixIcon: IconlyBold.message,
                    child: 'Nom',
                    obscureText: false),
                CustumTextField(
                    controller: prenom,
                    prefixIcon: IconlyBold.message,
                    child: 'Prénom',
                    obscureText: false),
                CustumTextField(
                    controller: telephone,
                    prefixIcon: IconlyBold.message,
                    keyboardType: TextInputType.number,
                    child: 'Telephone',
                    obscureText: false),
                CustumTextField(
                    controller: email,
                    prefixIcon: IconlyBold.message,
                    child: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 60.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(35.0)),
                      child: DropdownButton(
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(IconlyBold.profile,
                                    color: Colors.grey),
                                const SizedBox(width: 7.0),
                                CustomText(data: grade),
                              ],
                            ),
                          ),
                          focusColor: Colors.black,
                          iconEnabledColor: Colors.black,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                              value: "admin",
                              child: CustomText(data: "admin"),
                            ),
                            DropdownMenuItem(
                              value: "vendeur",
                              child: CustomText(data: "vendeur"),
                            ),
                          ],
                          onChanged: (s) {
                            setState(() {
                              grade = s!;
                            });
                          })),
                ),
                const SizedBox(height: 8.0),
                CustomButton(
                  child: "Créer un compte",
                  onPressed: () {
                    if (nom.text.isEmpty ||
                        prenom.text.isEmpty ||
                        telephone.text.isEmpty ||
                        email.text.isEmpty ||
                        grade == "Type compte") {
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
                    } else {
                      var user = Users(
                        createAt: DateTime.now().toIso8601String(),
                        nom: nom.text.trim(),
                        prenom: prenom.text.trim(),
                        telephone: telephone.text.trim(),
                        email: email.text.trim(),
                        grade: grade.trim(),
                        status: "acif",
                        messagingToken: "vide",
                        
                      );
                      locator.get<ServiceAuth>().inscription(
                          context: context,
                          email: user.email,
                          pass: "$grade.trim()12345",
                          user: user);
                    }
                  },
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dialogue(
      {required PanaraDialogType panaraDialogType,
      BuildContext? context,
      String? message,
      String? title}) {
    PanaraInfoDialog.show(
      panaraDialogType: panaraDialogType,
      context!,
      title: title,
      message: message!,
      buttonText: "Okay",
      onTapDismiss: () {
        Navigator.pop(context);
      },
    );
  }
}
