import 'package:flutter/material.dart';

import '../../widgets/custom_text.dart';

// ce widget est pour afficher le nombre de boutique d'un administrateur
class NombreBoutique extends StatelessWidget {
  final String nombre;
  const NombreBoutique({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      width: 160.0,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                data: nombre,
                overflow: TextOverflow.ellipsis,
                fontSize: 55.0,
              ),
            ),
          ),
          const CustomText(
            data: "Boutique",
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10.0)
        ],
      ),
    );
  }
}
