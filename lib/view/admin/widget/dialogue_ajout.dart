import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dialogueAjout({BuildContext? context, Widget? child}) => showDialog(
    context: context!,
    builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
        ));

dialogueAjout2({BuildContext? context, Widget? child}) =>
    showCupertinoDialog(context: context!, builder: (context) => child!);
