import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(data: "Profil")),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Text(
                """Bienvenue sur l'application de gestion des stocks développée par SAMORI ! 🚀

Notre application a été conçue pour simplifier et optimiser la gestion des stocks, offrant une solution efficace et conviviale pour les entreprises multi-boutiques. Que vous soyez propriétaire d'une petite entreprise ou d'une chaîne de magasins, notre application vous permet de gérer facilement vos stocks avec précision et simplicité.

Caractéristiques principales :

📦 Gestion Multi-boutique : Centralisez et organisez les stocks de plusieurs boutiques au sein d'une seule et même plateforme. SAMORI permet une gestion transparente et efficace, vous offrant une vue d'ensemble complète de l'inventaire de chaque emplacement.

🔄 Mises à Jour en Temps Réel : Grâce à des mises à jour en temps réel, soyez toujours informé de l'état actuel de vos stocks. Évitez les ruptures de stock et maximisez l'efficacité opérationnelle.

📊 Rapports Analytiques : Analysez les tendances de vente, identifiez les produits les plus performants et prenez des décisions éclairées. SAMORI propose des rapports analytiques détaillés pour vous aider à comprendre le comportement de votre inventaire.

🔒 Sécurité et Confidentialité : Nous comprenons l'importance de la sécurité des données. SAMORI intègre des fonctionnalités de sécurité robustes pour garantir la confidentialité de vos informations et la protection de vos données.

Contactez-nous :

Pour toute question, suggestion ou assistance, n'hésitez pas à nous contacter à l'adresse e-mail suivante : contact@samori-app.com

Réseaux Sociaux :

Suivez-nous sur Twitter et consultez notre code source sur GitHub pour rester à jour sur les dernières fonctionnalités et les mises à jour.""")
          ],
        ),
      ),
    );
  }
}
