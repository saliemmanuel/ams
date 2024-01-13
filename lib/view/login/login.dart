import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/themes/theme.dart';
import 'package:ams/view/widgets/app_body.dart';
import 'package:ams/view/widgets/check_email.dart';
import 'package:ams/view/widgets/custom_button.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:ams/view/widgets/custum_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../widgets/custom_dialogue_card.dart';
import '../widgets/custom_layout_builder.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var mdp = TextEditingController();
  var emailMDP = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: AppBody(
        appBar: AppBar(),
        bodys: Padding(
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
                          data: "Connexion à AMS",
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 10.0),
                        CustomText(
                            data: 'Renseignez un e-mail et un mot de passe'),
                        SizedBox(height: 15.0),
                      ]),
                ),
                CustumTextField(
                    controller: email,
                    prefixIcon: IconlyBold.message,
                    keyboardType: TextInputType.emailAddress,
                    child: 'Email',
                    obscureText: false),
                CustumTextField(
                    controller: mdp,
                    prefixIcon: IconlyBold.lock,
                    keyboardType: TextInputType.text,
                    child: 'Mot de passe',
                    obscureText: true),
                const SizedBox(height: 8.0),
                CustomButton(
                  child: "Se connecter",
                  onPressed: () {
                    if (email.text.isEmpty || mdp.text.isEmpty) {
                      dialogue(
                          panaraDialogType: PanaraDialogType.error,
                          message: "Entrez un e-mail et un mot de passe.",
                          title: "",
                          context: context);
                    } else if (!CheckEmail.isEmail(email.text)) {
                      dialogue(
                          panaraDialogType: PanaraDialogType.warning,
                          message: "Entrez un e-mail valide",
                          title: "",
                          context: context);
                    } else {
                      locator.get<ServiceAuth>().connexion(
                          context: context,
                          email: email.text.trim(),
                          pass: mdp.text.trim());
                    }
                  },
                  color: Colors.white,
                ),
                TextButton(
                  child: const CustomText(
                    data: "Mot de passe oublier?",
                    color: Palette.primary,
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                        backgroundColor: Colors.white,
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.close)),
                                    ],
                                  ),
                                ),
                                const CustomText(
                                  data: "Mot de passe oublié",
                                  fontSize: 30.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 10.0),
                                const CustomText(
                                    data: 'Renseignez votre e-mail'),
                                CustumTextField(
                                    controller: emailMDP,
                                    prefixIcon: IconlyBold.message,
                                    keyboardType: TextInputType.emailAddress,
                                    child: 'Email',
                                    obscureText: false),
                                const SizedBox(height: 8.0),
                                CustomButton(
                                  child: "Valider",
                                  onPressed: () {
                                    if (emailMDP.text.isEmpty) {
                                      dialogue(
                                          panaraDialogType:
                                              PanaraDialogType.error,
                                          message: "Entrez un e-mail svp!",
                                          title: "",
                                          context: context);
                                    } else if (!CheckEmail.isEmail(
                                        emailMDP.text)) {
                                      dialogue(
                                          panaraDialogType:
                                              PanaraDialogType.warning,
                                          message: "Entrez un e-mail valide",
                                          title: "",
                                          context: context);
                                    } else {
                                      locator
                                          .get<ServiceAuth>()
                                          .restaurePasswordByEmail(
                                            context: context,
                                            email: emailMDP.text.trim(),
                                          );
                                    }
                                  },
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
