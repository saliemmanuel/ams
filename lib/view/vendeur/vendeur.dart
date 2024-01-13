import 'package:ams/models/boutique_model.dart';
import 'package:ams/models/user.dart';
import 'package:ams/view/vendeur/bilan/bilan_vendeur.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import '../widgets/custom_layout_builder.dart';
import 'home/vendeur_home.dart';
import 'profil/vendeur_profil.dart';

class VendeursH extends StatefulWidget {
  final Users users;
  final BoutiqueModels boutique;
  const VendeursH({super.key, required this.users, required this.boutique});

  @override
  State<VendeursH> createState() => _VendeursHState();
}

class _VendeursHState extends State<VendeursH> {
  int topIndex = 0;
  @override
  Widget build(BuildContext context) {
    var page = [
      VendeurHome(users: widget.users, boutique: widget.boutique),
      BilanVendeur(boutique: widget.boutique),
      VendeurProfil(user: widget.users),
    ];
    return Scaffold(
      body: CustomLayoutBuilder(child: page[topIndex]),
      bottomNavigationBar: Consumer<HomeProvider>(
          builder: (contexte, values, child) => BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.home), label: 'Accueil'),
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.wallet), label: 'Mes ventes'),
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.profile), label: 'Profil'),
                ],
                onTap: (value) {
                  topIndex = value;
                  setState(() {});
                },
                currentIndex: topIndex,
              )),
    );
  }
}
