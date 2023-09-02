import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/app_body.dart';
import 'package:ams/view/widgets/check_email.dart';
import 'package:ams/view/widgets/custom_button.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:ams/view/widgets/custum_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../widgets/custom_dialogue_card.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var mdp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppBody(
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
              // CustomButton(
              //   child: "Create Account",
              //   onPressed: () {
              //     Get.to(const CreateAccount());
              //   },
              //   color: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
