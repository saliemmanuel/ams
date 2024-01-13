import 'package:flutter/material.dart';

import 'custom_button.dart';

bottomSheetExit(BuildContext context,
    {String? title, VoidCallback? onConfirm, VoidCallback? onCancel}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    height: 150,
    decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: CustomButton(child: "Non", onPressed: onCancel),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: CustomButton(
                    color: Colors.red, child: 'Oui', onPressed: onConfirm),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
