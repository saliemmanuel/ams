import 'package:ams/models/user.dart';
import 'package:ams/services/services_auth.dart';
import 'package:flutter/material.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../admin/widget/dialogue_ajout.dart';
import '../../admin/widget/edit_widget.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/edite_profil.dart';

class VendeurProfil extends StatefulWidget {
  final Users user;
  const VendeurProfil({super.key, required this.user});

  @override
  State<VendeurProfil> createState() => _VendeurProfilState();
}

class _VendeurProfilState extends State<VendeurProfil> {
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
