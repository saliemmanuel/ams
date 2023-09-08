import 'package:ams/models/user.dart';
import 'package:flutter/material.dart';

import '../../../provider/home_provider.dart';
import '../../../services/service_locator.dart';
import '../../widgets/custom_text.dart';

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
