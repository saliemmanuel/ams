import 'package:ams/services/service_locator.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ams/models/user.dart';
import 'package:new_pinput/new_pinput.dart';

import 'custom_button.dart';

class UpdateCodeUser extends StatefulWidget {
  final Users users;

  const UpdateCodeUser({
    super.key,
    required this.users,
  });

  @override
  State<UpdateCodeUser> createState() => _UpdateCodeUserState();
}

class _UpdateCodeUserState extends State<UpdateCodeUser> {
  var code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
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
                  data: "  Entrez nouveau code secret",
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
                  locator.get<ServiceAuth>().getUpdateUserCode(
                        context: context,
                        users: widget.users,
                        code: code.text,
                      );
                },
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                  child: "Validez",
                  color: Colors.white,
                  onPressed: () {
                    locator.get<ServiceAuth>().getUpdateUserCode(
                        context: context, users: widget.users, code: code.text);
                  }),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
