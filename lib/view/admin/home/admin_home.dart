import 'package:ams/models/user.dart';
import 'package:ams/view/admin/home/ajout_boutique/ajout_boutique.dart';
import 'package:ams/view/admin/home/detail_boutique/detail_boutique.dart';
import 'package:ams/view/admin/widget/ajout_boutique_card.dart';
import 'package:ams/view/admin/widget/boutique_card.dart';
import 'package:ams/view/admin/widget/dialogue_ajout.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_provider.dart';
import '../../widgets/custom_search_bar.dart';
import '../widget/nombre_boutique.dart';

class AdminHome extends StatefulWidget {
  final Users users;
  const AdminHome({super.key, required this.users});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int topIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Accueil"),
      ),
      body: ListView(
        children: [
          CustomSearchBar(onTap: () {}),
          Container(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  AjoutBoutiqueCard(
                    onTap: () {
                      dialogueAjout(child: AjoutBoutique(), context: context);
               
                    },
                  ),
                  const NombreBoutique(nombre: "13")
                ],
              )),
          const Divider(),
          const ListTile(
            title: CustomText(
              data: "Liste des Boutiques",
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return BoutiqueCard(
                    nomBoutique: "Boutique marché central",
                    onTap: () {
                      Get.to(const DetailBoutique());
                    },
                  );
                },
              )),
        ],
      ),
      bottomNavigationBar: Consumer<HomeProvider>(
          builder: (contexte, values, child) => BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.home), label: 'Accueil'),
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.profile), label: 'Profil')
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
