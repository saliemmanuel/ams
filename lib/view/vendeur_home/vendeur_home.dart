import 'package:ams/models/user.dart';
import 'package:flutter/material.dart';

class VendeurHome extends StatefulWidget {
  final Users users;
  const VendeurHome({super.key, required this.users});

  @override
  State<VendeurHome> createState() => _VendeurHomeState();
}

class _VendeurHomeState extends State<VendeurHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("jdjskd"),
      ),
      body: ListView(
        children: const [Text("Vendeur")],
      ),
    );
  }
}
