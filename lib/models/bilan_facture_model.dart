import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ams/models/facture_client_model.dart';
import 'package:ams/models/vendeur_model.dart';

class BilanFactureModel {
  final List<FactureClient> facture;
  final String idBoutique;
  final double netPayer;
  final String nom;
  final String telephone;
  final Vendeur vendeur;
  final String createAt;
  BilanFactureModel({
    required this.facture,
    required this.idBoutique,
    required this.netPayer,
    required this.nom,
    required this.telephone,
    required this.vendeur,
    required this.createAt,
  });

  BilanFactureModel copyWith({
    List<FactureClient>? facture,
    String? idBoutique,
    double? netPayer,
    String? nom,
    String? telephone,
    Vendeur? vendeur,
    String? createAt,
  }) {
    return BilanFactureModel(
      facture: facture ?? this.facture,
      idBoutique: idBoutique ?? this.idBoutique,
      netPayer: netPayer ?? this.netPayer,
      nom: nom ?? this.nom,
      telephone: telephone ?? this.telephone,
      vendeur: vendeur ?? this.vendeur,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'facture': facture.map((x) => x.toMap()).toList(),
      'idBoutique': idBoutique,
      'netPayer': netPayer,
      'nom': nom,
      'telephone': telephone,
      'vendeur': vendeur.toMap(),
      'createAt': createAt,
    };
  }

  factory BilanFactureModel.fromMap(Map<String, dynamic> map) {
    return BilanFactureModel(
      facture: List<FactureClient>.from(
        (map['facture'] as List<dynamic>).map<FactureClient>(
          (x) => FactureClient.fromMap(x as Map<String, dynamic>),
        ),
      ),
      idBoutique: map['idBoutique'] as String,
      netPayer: map['netPayer'] as double,
      nom: map['nom'] as String,
      telephone: map['telephone'] as String,
      vendeur: Vendeur.fromMap(map['vendeur'] as Map<String, dynamic>),
      createAt: map['createAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BilanFactureModel.fromJson(String source) =>
      BilanFactureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BilanFactureModel(facture: $facture, idBoutique: $idBoutique, netPayer: $netPayer, nom: $nom, telephone: $telephone, vendeur: $vendeur, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant BilanFactureModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.facture, facture) &&
        other.idBoutique == idBoutique &&
        other.netPayer == netPayer &&
        other.nom == nom &&
        other.telephone == telephone &&
        other.vendeur == vendeur &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return facture.hashCode ^
        idBoutique.hashCode ^
        netPayer.hashCode ^
        nom.hashCode ^
        telephone.hashCode ^
        vendeur.hashCode ^
        createAt.hashCode;
  }
}
