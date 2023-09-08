import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String child;
  final StrutStyle? strutStyle;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? color;
  final Color? selectionColor;
  final double? fontSize;
  const CustomButton(
      {super.key,
      this.onPressed,
      required this.child,
      this.strutStyle,
      this.fontWeight,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior,
      this.color,
      this.selectionColor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: CustomText(
                  data: child,
                  color: color,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
