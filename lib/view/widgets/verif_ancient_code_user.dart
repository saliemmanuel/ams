import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ams/models/user.dart';
import 'package:new_pinput/new_pinput.dart';

import 'custom_button.dart';
import 'custom_layout_builder.dart';

class VerificationAncientCode extends StatefulWidget {
  final Users users;

  final dynamic Function(bool) callBack;

  const VerificationAncientCode({
    super.key,
    required this.users,
    required this.callBack,
  });

  @override
  State<VerificationAncientCode> createState() =>
      _VerificationAncientCodeState();
}

class _VerificationAncientCodeState extends State<VerificationAncientCode> {
  var code = TextEditingController();

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
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomText(
                    data: "  Entrez ancient code secret",
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Pinput(
                  length: 4,
                  obscureText: true,
                  controller: code,
                  autofocus: true,
                  obscuringCharacter: "#",
                  onCompleted: (pin) {
                    locator.get<ServiceAuth>().getVerifUserCode(
                        context: context,
                        users: widget.users,
                        code: code.text,
                        callBack: widget.callBack);
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                    child: "Validez",
                    color: Colors.white,
                    onPressed: () {
                      locator.get<ServiceAuth>().getVerifUserCode(
                          context: context,
                          users: widget.users,
                          code: code.text,
                          callBack: widget.callBack);
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
