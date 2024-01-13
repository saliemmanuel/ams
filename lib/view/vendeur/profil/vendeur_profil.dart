import 'package:ams/models/user.dart';
import 'package:ams/services/services_auth.dart';
import 'package:ams/view/widgets/update_code_user.dart';
import 'package:ams/view/widgets/verif_ancient_code_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../admin/widget/dialogue_ajout.dart';
import '../../widgets/create_code_user.dart';
import '../../widgets/custom_dialogue.dart';
import '../../widgets/custom_dialogue_card.dart';
import '../../widgets/custom_layout_builder.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/edite_profil.dart';

class VendeurProfil extends StatefulWidget {
  final Users user;
  const VendeurProfil({super.key, required this.user});

  @override
  State<VendeurProfil> createState() => _VendeurProfilState();
}

class _VendeurProfilState extends State<VendeurProfil> {
  var scaffoldStateKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        key: scaffoldStateKey,
        appBar: AppBar(title: const CustomText(data: "Profil")),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Card(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25.0),
                    StreamBuilder(
                      stream: locator
                          .get<ServiceAuth>()
                          .firestore
                          .collection('users')
                          .where('id', isEqualTo: widget.user.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var user = Users.fromMap(
                                    snapshot.data!.docs[index].data());
                                return ListTile(
                                  title: CustomText(
                                    data: '${user.nom} ${user.prenom ?? "#"} ',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        dialogueAjout2(
                                            context: context,
                                            child:
                                                EditeProfil(users: widget.user));
                                      },
                                      icon: const Icon(Icons.edit)),
                                );
                              });
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                    ListTile(
                      title: CustomText(data: widget.user.email ?? ""),
                    ),
                    const SizedBox(height: 25.0),
                  ],
                )),
              ),
              // StreamBuilder(
              //   stream: locator
              //       .get<ServiceAuth>()
              //       .firestore
              //       .collection("code")
              //       .where("id", isEqualTo: widget.user.id)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       if (snapshot.data!.docs.isNotEmpty) {
              //         return Card(
              //           child: ListTile(
              //             onTap: () {
              //               Get.back();
              //               dialogueAjout2(
              //                   context: context,
              //                   child: VerificationAncientCode(
              //                     users: widget.user,
              //                     callBack: (value) {
              //                       Get.back();
              //                       if (value) {
              //                         dialogueAjout2(
              //                             context: context,
              //                             child: UpdateCodeUser(
              //                               users: widget.user,
              //                             ));
              //                       } else {
              //                         dialogueAndonTapDismiss(
              //                             onTapDismiss: () {
              //                               Get.back();
              //                             },
              //                             panaraDialogType:
              //                                 PanaraDialogType.error,
              //                             message: "Code secret incorrect",
              //                             title: "",
              //                             context: context);
              //                       }
              //                     },
              //                   ));
              //             },
              //             leading: const Icon(Icons.lock),
              //             title: const CustomText(data: " Changer code secret"),
              //           ),
              //         );
              //       } else if (snapshot.data!.docs.isEmpty) {
              //         return Card(
              //           child: ListTile(
              //             onTap: () {
              //               Get.back();
              //               dialogueAjout2(
              //                   context: context,
              //                   child: CreateCodeUser(users: widget.user));
              //             },
              //             leading: const Icon(Icons.lock),
              //             title: const CustomText(data: "Créer code secret"),
              //           ),
              //         );
              //       }
              //     }
              //     return const Row(
              //       children: [CupertinoActivityIndicator()],
              //     );
              //   },
              // ),
              Card(
                  child: ListTile(
                title: const CustomText(data: "Déconnexion", color: Colors.red),
                leading: const Icon(Icons.logout, color: Colors.red),
                onTap: () {
                  scaffoldStateKey.currentState?.showBottomSheet(
                    (context) {
                      return bottomSheetExit(
                        context,
                        title: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                        onConfirm: () async {
                          try {
                            locator.get<HomeProvider>().destroyUser();
                          } finally {
                            Get.back();
                          }
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 2,
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
