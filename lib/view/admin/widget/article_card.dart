import 'package:ams/models/article_modes.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_layout_builder.dart';
import '../../widgets/custom_text.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModels articleModels;
  final void Function()? onTap;
  const ArticleCard({super.key, this.onTap, required this.articleModels});

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false)
        .setValeurStockBoutique(articleModels.prixVente);
    return CustomLayoutBuilder(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: articleModels.stockActuel! < articleModels.stockCritique!
                ? articleModels.stockActuel! == 0
                    ? Colors.red
                    : Colors.red
                : articleModels.stockActuel! < articleModels.stockNormal!
                    ? Colors.amber
                    : Colors.green,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            leading: const Icon(IconlyBold.image_2, size: 55.0),
            title: CustomText(
                data: articleModels.designation!,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(data: "Prix de vente : ${articleModels.prixVente}"),
                CustomText(data: "Stock Actuel : ${articleModels.stockActuel}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
