import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../themes/theme.dart';

class CustumTextField extends StatefulWidget {
  final String? child;
  final Color? bacgroundColor;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? enabled;
  final IconData? prefixIcon;
  final int? maxLines;
  final Color? prefixIconColor;

  const CustumTextField(
      {Key? key,
      this.child,
      this.borderRadius,
      this.fontSize,
      this.textColor,
      this.bacgroundColor,
      this.controller,
      required this.obscureText,
      this.keyboardType,
      this.onChanged,
      this.maxLength,
      this.focusNode,
      this.enabled,
      this.prefixIcon,
      this.maxLines = 1,
      this.prefixIconColor = Colors.grey})
      : assert(child != null, 'child de type String ne doit pas être  null'),
        super(key: key);

  @override
  CustumTextFieldState createState() => CustumTextFieldState();
}

class CustumTextFieldState extends State<CustumTextField> {
  bool obscure = false;
  @override
  void initState() {
    obscure = widget.obscureText!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        maxLength: widget.maxLength,
        obscureText: obscure == false ? false : true,
        autocorrect: true,
        controller: widget.controller,
        cursorHeight: 18,
        keyboardType: widget.keyboardType,
        cursorColor: Palette.primary,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Palette.primary)),
          labelText: widget.child!,
          hintText: widget.child,
          prefixIconColor: widget.prefixIconColor!,
          prefixIcon:
              widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
          suffixIcon: widget.obscureText == true
              ? IconButton(
                  icon: obscure
                      ? const Icon(IconlyBold.lock, color: Colors.grey)
                      : const Icon(IconlyBold.unlock, color: Palette.primary),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
