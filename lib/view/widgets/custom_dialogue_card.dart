import 'package:ams/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'custom_button.dart';

dialogue(
    {required PanaraDialogType panaraDialogType,
    required BuildContext? context,
    required String? message,
    required String? title}) {
  PanaraInfoDialog.show(
    panaraDialogType: panaraDialogType,
    context!,
    title: title,
    message: message!,
    buttonText: "Okay",
    onTapDismiss: () {
      Get.back();
    },
  );
}

dialogueAndonTapDismiss(
    {required PanaraDialogType panaraDialogType,
    BuildContext? context,
    String? message,
    String? title,
    required void Function() onTapDismiss}) {
  PanaraInfoDialog.show(
      panaraDialogType: panaraDialogType,
      context!,
      title: title,
      message: message!,
      buttonText: "Okay",
      onTapDismiss: onTapDismiss);
}

dialogueAndonTapDismissCustomButtonText(
    {required PanaraDialogType panaraDialogType,
    BuildContext? context,
    String? message,
    required String cancelButtonText,
    required String confirmButtonText,
    required void Function() onTapCancel,
    required void Function() onTapConfirm}) {
  PanaraConfirmDialog.show(
    panaraDialogType: panaraDialogType,
    context!,
    message: message!,
    cancelButtonText: cancelButtonText,
    confirmButtonText: confirmButtonText,
    onTapCancel: onTapCancel,
    onTapConfirm: onTapConfirm,
  );
}

confirmDialogue(
    {required PanaraDialogType panaraDialogType,
    BuildContext? context,
    String? message,
    String? title,
    required void Function() onTapConfirm}) {
  PanaraConfirmDialog.show(
    context!,
    title: title,
    message: message!,
    buttonTextColor: Colors.white,
    confirmButtonText: "Supprimer",
    cancelButtonText: "Annuler",
    onTapCancel: () {
      Get.back();
    },
    onTapConfirm: onTapConfirm,
    panaraDialogType: panaraDialogType,
  );
}

Future simpleDialogueCard(String title, String msg, BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 15.0),
              Text(msg)
            ],
          ),
        );
      });
}



Future simpleDialogueCardSansTitle(String msg, BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 15.0),
                Expanded(child: Text(msg))
              ],
            ),
          ),
        );
      });
}

Future errorDialogueCard(String title, String msg, BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 10.0),
              child: CustomButton(
                child: "Ok",
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      });
}

Future echecTransaction(String msg, BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0),
              CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.3),
                radius: 30.0,
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 50.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(msg, textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 10.0),
              child: CustomButton(
                child: "Ok",
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      });
}

Future succesTransaction(String msg, BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.3),
                  radius: 30.0,
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 50.0,
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(msg, textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 10.0),
              child: CustomButton(
                child: "Ok",
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      });
}

selectSectionAlert(
    {BuildContext? context,
    String? titleESG,
    String? titleEST,
    Function()? onTapESG,
    Function()? onTapEST}) {
  return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.domain, color: Palette.primary),
                  onTap: onTapESG,
                  title: Text(titleESG!),
                ),
                const SizedBox(height: 15.0),
                ListTile(
                  leading: const Icon(Icons.domain, color: Palette.primary),
                  onTap: onTapEST,
                  title: Text(titleEST!),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CustomButton(
                child: "Fermer",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      });
}

listWidgetOnAlert({BuildContext? context, List<Widget>? children}) {
  return showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: children!,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CustomButton(
                child: "Fermer",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      });
}
