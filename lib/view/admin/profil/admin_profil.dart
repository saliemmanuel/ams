import 'package:ams/models/user.dart';
import 'package:ams/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/service_locator.dart';
import '../../create_account/create_account.dart';
import '../../widgets/custom_text.dart';

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
                  CustomText(
                    data: '${widget.user.nom} ${widget.user.prenom} ',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
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
