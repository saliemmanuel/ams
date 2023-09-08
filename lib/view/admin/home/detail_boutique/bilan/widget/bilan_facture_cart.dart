import 'package:ams/models/bilan_facture_model.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../widgets/custom_text.dart';

class BilanFactureCard extends StatelessWidget {
  final BilanFactureModel bilanFactureModel;
  final void Function()? onTap;
  const BilanFactureCard(
      {super.key, this.onTap, required this.bilanFactureModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          leading: const Icon(IconlyBold.image_2, size: 55.0),
          title: CustomText(
              data:
                  "${bilanFactureModel.nom} ",
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(data: "Net payer : ${bilanFactureModel.netPayer}"),
              CustomText(data: "Le : ${bilanFactureModel.createAt}"),
            ],
          ),
        ),
      ),
    );
  }
}
