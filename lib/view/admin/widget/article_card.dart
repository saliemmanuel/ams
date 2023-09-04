import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/vendeur_model.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/custom_dialogue_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_text.dart';

class ArticleCard extends StatelessWidget {
  final void Function()? onTap;
  const ArticleCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 185.0,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/article.png', height: 100.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    data: "CARTON FORMAT 80g",
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
                CustomText(data: "Prix Achat : 20000"),
                CustomText(data: "Prix de vente : 30000"),
                CustomText(data: "Stock Actuel : 3000"),
                CustomText(data: "Stock Normal : 20"),
                CustomText(data: "Stock Critique : 10 "),
              ],
            ),
            Column(
              children: [
                IconButton.filled(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton.filled(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange)),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton.filled(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple)),
                  icon: const Icon(Icons.visibility, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
