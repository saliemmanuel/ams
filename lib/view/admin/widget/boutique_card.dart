import 'package:flutter/material.dart';

import '../../widgets/custom_text.dart';

class BoutiqueCard extends StatelessWidget {
  final String? nomBoutique;
  final void Function()? onTap;
  const BoutiqueCard({super.key, this.nomBoutique, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Image.asset('assets/images/boutique.png'),
          title: CustomText(
            data: nomBoutique!,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
    );
  }
}
