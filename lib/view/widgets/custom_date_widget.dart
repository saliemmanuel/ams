import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomDetailWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? nullVal;
  final Widget? child;
  final Function()? onTap;
  const CustomDetailWidget(
      {super.key,
      required this.title,
      this.subtitle,
      this.child,
      this.onTap,
      this.nullVal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Align(
              alignment: Alignment.centerLeft, child: CustomText(data: title)),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10.0),
            height: 54.5,
            width: double.infinity,
            margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey)),
            child: child ?? CustomText(data: subtitle ?? nullVal!),
          ),
        ),
      ],
    );
  }
}