import 'dart:async';

import 'package:ams/themes/theme.dart';
import 'package:flutter/material.dart';

import '../../auth/firebase_auth.dart';
import '../../services/service_locator.dart';
import '../../services/services_auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class VerficationEmailView extends StatefulWidget {
  const VerficationEmailView({super.key});

  @override
  State<VerficationEmailView> createState() => _VerficationEmailViewState();
}

class _VerficationEmailViewState extends State<VerficationEmailView> {
  int time = 15;
  int currentValuerTime = 0;
  int cliquerTroisFois = 0;
  Timer? timer;
  Timer? xTimer;
  @override
  void initState() {
    currentValuerTime = time;
    xTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (time != 0) {
        time--;
      }
      if (time == 0) {
        time = 0;
      }
      setState(() {});
    });
    checkVerification();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => checkVerification(),
    );
    super.initState();
  }

  checkVerification() {
    locator.get<FirebasesAuth>().curentUser!.reload();
    if (locator.get<FirebasesAuth>().curentUser!.emailVerified) {
      // context.pushReplacement('/CreateUserAccountView');
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    xTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        willPopScope();
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () => willPopScope(),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    color: Palette.primary,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    const CustomText(
                        data: "Confirmation E-mail",
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    const SizedBox(height: 15.0),
                    CustomText(
                      data:
                          "Un lien de vérification a été envoyer au ${locator.get<ServiceAuth>().maskEmail(locator.get<FirebasesAuth>().curentUser!.email!)}",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    if (cliquerTroisFois != 3)
                      Wrap(
                        children: [
                          const CustomText(
                            data: "Renvoyer le lien à nouveau dans",
                            textAlign: TextAlign.center,
                          ),
                          if (time != 0)
                            CustomText(
                              data: ": $time",
                              textAlign: TextAlign.center,
                            ),
                          if (time == 0)
                            TextButton(
                                onPressed: () {
                                  locator
                                      .get<FirebasesAuth>()
                                      .curentUser!
                                      .sendEmailVerification();
                                  currentValuerTime += 20;
                                  time = currentValuerTime;
                                  cliquerTroisFois++;
                                  setState(() {});
                                },
                                child: const CustomText(data: "Renvoyer"))
                        ],
                      ),
                    const SizedBox(height: 10.0)
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  willPopScope() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText(
            data:
                "Voulez vous vraiment quitter cette pages ? cela annulera votre inscription.",
            fontSize: 16.0),
        actions: [
          Column(
            children: [
              CustomButton(
                child: "Quitter",
                fontSize: 20.0,
                onPressed: () async {
                  locator.get<FirebasesAuth>().curentUser!.delete();
                  locator.get<FirebasesAuth>().signOut();
                  locator.get<FirebasesAuth>().deleteUserAccount();
                  // context.pushReplacement('/LoginView');
                },
              ),
              const SizedBox(height: 15.0),
              CustomButton(
                  child: "Annuler",
                  fontSize: 20.0,
                  onPressed: () => Navigator.pop(context)),
            ],
          )
        ],
      ),
    );
  }
}
