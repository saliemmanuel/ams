import 'package:flutter/material.dart';

import '../../widgets/custom_text.dart';

// ce widget est pour afficher le nombre de boutique d'un administrateur
class HomeCardWidget extends StatelessWidget {
  final Widget child;
  final String label;
  final void Function()? onTap;
  const HomeCardWidget(
      {super.key,
      required this.child,
      required this.onTap,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 160.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                Padding(padding: const EdgeInsets.all(8.0), child: child),
                const SizedBox(height: 10.0)
              ],
            ),
          ),
          Expanded(
            child: CustomText(
              data: label,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
