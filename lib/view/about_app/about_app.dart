import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_text.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(data: "Apropos")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                  textAlign: TextAlign.justify,
                  """Bienvenue sur l'application de gestion des stocks AMS (v1.1.6) ! 🚀
        
        Notre application a été conçue pour simplifier et optimiser la gestion des stocks, offrant une solution efficace et conviviale pour les entreprises multi-boutiques. Que vous soyez propriétaire d'une petite entreprise ou d'une chaîne de magasins, notre application vous permet de gérer facilement vos stocks avec précision et simplicité.
        
        Caractéristiques principales :
        
        📦 Gestion Multi-boutique : Centralisez et organisez les stocks de plusieurs boutiques au sein d'une seule et même plateforme. AMS permet une gestion transparente et efficace, vous offrant une vue d'ensemble complète de l'inventaire de chaque emplacement.
        
        🔄 Mises à Jour en Temps Réel : Grâce à des mises à jour en temps réel, soyez toujours informé de l'état actuel de vos stocks. Évitez les ruptures de stock et maximisez l'efficacité opérationnelle.
        
        🔒 Sécurité et Confidentialité : Nous comprenons l'importance de la sécurité des données. AMS intègre des fonctionnalités de sécurité robustes pour garantir la confidentialité de vos informations et la protection de vos données.
        
Développer par : SALI EMMANUEL
Contactez-nous :\n"""),
              OutlinedButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: "651 82 78 28"));
                  },
                  child: const Text(" WhatsApp : 651 82 78 28")),
              OutlinedButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: "698 06 68 96"));
                  },
                  child: const Text("Téléphone : 698 06 68 96")),
              OutlinedButton(
                  onPressed: () {},
                  child: const Text(" Email : saliemmanuelxy@gmail.com")),
              OutlinedButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: "saliemmanuelxy@gmail.com"));
                  },
                  child: const Text(" LinkedIn")),
              OutlinedButton(
                  onPressed: () {
                    _launchUrl(url: "https://github.com/saliemmanuel");
                  },
                  child: const Text(" Github")),
              OutlinedButton(
                  onPressed: () {
                    _launchUrl(
                        url:
                            "https://www.linkedin.com/in/sali-emmanuel-35ab3a28a/");
                  },
                  child: const Text("Porfolio")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl({String? url}) async {
    if (!await launchUrl(Uri.parse(url!))) {
      throw Exception('Could not launch $url');
    }
  }
}
