import 'package:ams/models/user.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:ams/view/widgets/create_code_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../services/service_locator.dart';
import '../../../services/services_auth.dart';
import '../../create_account/create_account.dart';
import '../../widgets/custom_dialogue_card.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/edite_profil.dart';
import '../../widgets/update_code_user.dart';
import '../../widgets/verif_ancient_code_user.dart';
import '../widget/dialogue_ajout.dart';

class AdminProfil extends StatefulWidget {
  final Users user;
  const AdminProfil({super.key, required this.user});

  @override
  State<AdminProfil> createState() => _AdminProfilState();
}

class _AdminProfilState extends State<AdminProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            StreamBuilder(
              stream: locator
                  .get<ServiceAuth>()
                  .firestore
                  .collection("code")
                  .where("id", isEqualTo: widget.user.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.back();
                          dialogueAjout2(
                              context: context,
                              child: VerificationAncientCode(
                                users: widget.user,
                                callBack: (value) {
                                  Get.back();
                                  if (value) {
                                    dialogueAjout2(
                                        context: context,
                                        child: UpdateCodeUser(
                                          users: widget.user,
                                        ));
                                  } else {
                                    dialogueAndonTapDismiss(
                                        onTapDismiss: () {
                                          Get.back();
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.error,
                                        message: "Code secret incorrect",
                                        title: "",
                                        context: context);
                                  }
                                },
                              ));
                        },
                        leading: const Icon(Icons.lock),
                        title: const CustomText(data: " Changer code secret"),
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.back();
                          dialogueAjout2(
                              context: context,
                              child: CreateCodeUser(users: widget.user));
                        },
                        leading: const Icon(Icons.lock),
                        title: const CustomText(data: "Créer code secret"),
                      ),
                    );
                  }
                }
                return const Row(
                  children: [CupertinoActivityIndicator()],
                );
              },
            ),
            Card(
                child: ListTile(
              title: const CustomText(data: "Créer un Admin"),
              leading: const Icon(Icons.person),
              onTap: () {
                Get.to(const CreateAccount());
              },
            )),
            Card(
                child: ListTile(
              title: const CustomText(data: "Déconnexion", color: Colors.red),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () {
                locator.get<HomeProvider>().destroyUser();
              },
            )),
          ],
        ),
      ),
    );
  }
}
