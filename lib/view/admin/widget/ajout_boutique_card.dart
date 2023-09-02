import 'package:flutter/material.dart';

import '../../widgets/custom_text.dart';

// ce widget est pourlà  permettre l'ajout d'une nouvelle boutique d'un administrateur
class AjoutBoutiqueCard extends StatelessWidget {
  final void Function()? onTap;
  const AjoutBoutiqueCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160.0,
        width: 160.0,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  size: 75.0,
                ),
              ),
            ),
            CustomText(
              data: "Boutique",
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }
}
