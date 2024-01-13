import 'package:ams/models/article_modes.dart';
import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dialogue_card.dart';
import '../../widgets/custom_layout_builder.dart';
import '../../widgets/custum_text_field.dart';

class EditeWidget extends StatefulWidget {
  final String label;
  final String previusValue;
  final String value;
  final ArticleModels article;
  final bool isString;
  final bool isDouble;

  const EditeWidget(
      {super.key,
      required this.label,
      required this.article,
      required this.value,
      required this.isString,
      required this.isDouble,
      required this.previusValue});

  @override
  State<EditeWidget> createState() => _EditeWidgetState();
}

class _EditeWidgetState extends State<EditeWidget> {
  TextEditingController? controller;
  @override
  void initState() {
    controller = TextEditingController(text: widget.previusValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Align(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                CustumTextField(
                    keyboardType: !widget.isString
                        ? TextInputType.number
                        : TextInputType.text,
                    controller: controller,
                    child: widget.label,
                    obscureText: false),
                const SizedBox(height: 8.0),
                CustomButton(
                    child: "Enregistrez",
                    color: Colors.white,
                    onPressed: () {
                      if (widget.label == "Nouveau nom") {
                        locator.get<ServiceAuth>().editStock(
                            article: widget.article,
                            context: context,
                            key: widget.value,
                            value: controller!.text);
                      } else {
                        if (!widget.isDouble) {
                          if (int.tryParse(controller!.text) == null) {
                            dialogue(
                                panaraDialogType: PanaraDialogType.error,
                                message: "Entrez un entier svp",
                                title: "",
                                context: context);
                          } else {
                            Provider.of<HomeProvider>(context, listen: false)
                                .setNombreBoutique(widget.article.idBoutique);
                            locator.get<ServiceAuth>().editStock(
                                article: widget.article,
                                context: context,
                                key: widget.value,
                                value: widget.isDouble
                                    ? double.parse(controller!.text)
                                    : int.parse(controller!.text));
                          }
                        } else {
                          Provider.of<HomeProvider>(context, listen: false)
                              .setNombreBoutique(widget.article.idBoutique);
                          locator.get<ServiceAuth>().editStock(
                              article: widget.article,
                              context: context,
                              key: widget.value,
                              value: double.parse(controller!.text));
                        }
                      }
                    }),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
