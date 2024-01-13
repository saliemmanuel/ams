import 'package:ams/storage/local_storage/local_storage.dart';
import 'package:ams/themes/theme.dart';
import 'package:ams/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_body.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_layout_builder.dart';
import '../widgets/custom_text.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var onboardingModel = OnboardingModel(
        'Bienvenue sur AMS',
        'Contrôler facilement la gestion de stock, la clientele où que vous sovez en toute sécurité et en toute simplicité!',
        'assets/images/i.png');

    return CustomLayoutBuilder(
      child: AppBody(
        bodys: Column(
          children: [
            Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Image.asset(onboardingModel.imagePath),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 25.0),
                          CustomText(
                            data: onboardingModel.title,
                            textAlign: TextAlign.center,
                            color: Palette.primary,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 25.0),
                          CustomText(
                            data: onboardingModel.describtion,
                            textAlign: TextAlign.center,
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      child: "Commencer",
                      onPressed: () {
                        LocalStorage().saveData(
                          key: "onboarding",
                          value: "onboarding",
                        );
                        Get.off(const Login());
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingModel {
  final String title;
  final String describtion;
  final String imagePath;

  OnboardingModel(this.title, this.describtion, this.imagePath);
}
