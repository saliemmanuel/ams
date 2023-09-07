import 'package:ams/view/admin/home/admin_home.dart';
import 'package:ams/view/admin/profil/admin_profil.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../provider/home_provider.dart';

class Admin extends StatefulWidget {
  final Users users;

  const Admin({super.key, required this.users});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int topIndex = 0;

  @override
  Widget build(BuildContext context) {
    var page = [
      AdminHome(users: widget.users),
      AdminProfil(user: widget.users)
    ];
    return Scaffold(
      body: page[topIndex],
      bottomNavigationBar: Consumer<HomeProvider>(
          builder: (contexte, values, child) => BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(IconlyBold.home), label: 'Accueil'),
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
