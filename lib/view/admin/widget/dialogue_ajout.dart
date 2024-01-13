import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_layout_builder.dart';

dialogueAjout({BuildContext? context, Widget? child}) => showDialog(
    context: context!,
    builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomLayoutBuilder(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), child: child)),
        ));

dialogueAjout2({required BuildContext? context, Widget? child}) =>
    showCupertinoDialog(
        context: context!,
        builder: (context) => CustomLayoutBuilder(child: child!));
