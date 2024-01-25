import 'package:ams/models/user.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/service_locator.dart';
import '../../../services/services_auth.dart';
import '../../about_app/about_app.dart';
import '../../create_account/create_account.dart';
import '../../widgets/custom_dialogue.dart';
import '../../widgets/custom_layout_builder.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/edite_profil.dart';
import '../widget/dialogue_ajout.dart';

class AdminProfil extends StatefulWidget {
  final Users user;
  const AdminProfil({super.key, required this.user});

  @override
  State<AdminProfil> createState() => _AdminProfilState();
}

class _AdminProfilState extends State<AdminProfil> {
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
                                            child: EditeProfil(
                                                users: widget.user));
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
              Card(
                  child: ListTile(
                title: const CustomText(data: "Ajouter un compte"),
                leading: const Icon(Icons.person),
                onTap: () {
                  Get.to(const CreateAccount());
                },
              )),
              Card(
                  child: ListTile(
                title: const CustomText(data: "Apros de l'application"),
                leading: const Icon(Icons.info),
                onTap: () {
                  Get.to(const AboutApp());
                },
              )),
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
