import 'dart:convert';

import 'package:ams/models/vendeur_model.dart';

class BoutiqueModels {
  final String? nomBoutique;
  final String? villeBoutique;
  final String? quartierBoutique;
  final String? dateCreation;
  final String? idAdmin;
  final Vendeur vendeurBoutique;
  BoutiqueModels({
    this.nomBoutique,
    this.villeBoutique,
    this.quartierBoutique,
    this.dateCreation,
    this.idAdmin,
    required this.vendeurBoutique,
  });

  BoutiqueModels copyWith({
    String? nomBoutique,
    String? villeBoutique,
    String? quartierBoutique,
    String? dateCreation,
    String? idAdmin,
    Vendeur? vendeurBoutique,
  }) {
    return BoutiqueModels(
      nomBoutique: nomBoutique ?? this.nomBoutique,
      villeBoutique: villeBoutique ?? this.villeBoutique,
      quartierBoutique: quartierBoutique ?? this.quartierBoutique,
      dateCreation: dateCreation ?? this.dateCreation,
      idAdmin: idAdmin ?? this.idAdmin,
      vendeurBoutique: vendeurBoutique ?? this.vendeurBoutique,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomBoutique': nomBoutique,
      'villeBoutique': villeBoutique,
      'quartierBoutique': quartierBoutique,
      'dateCreation': dateCreation,
      'idAdmin': idAdmin,
      'vendeurBoutique': vendeurBoutique.toMap(),
    };
  }

  factory BoutiqueModels.fromMap(Map<String, dynamic> map) {
    return BoutiqueModels(
      nomBoutique:
          map['nomBoutique'] != null ? map['nomBoutique'] as String : null,
      villeBoutique:
          map['villeBoutique'] != null ? map['villeBoutique'] as String : null,
      quartierBoutique: map['quartierBoutique'] != null
          ? map['quartierBoutique'] as String
          : null,
      dateCreation:
          map['dateCreation'] != null ? map['dateCreation'] as String : null,
      idAdmin: map['idAdmin'] != null ? map['idAdmin'] as String : null,
      vendeurBoutique:
          Vendeur.fromMap(map['vendeurBoutique'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BoutiqueModels.fromJson(String source) =>
      BoutiqueModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BoutiqueModels(nomBoutique: $nomBoutique, villeBoutique: $villeBoutique, quartierBoutique: $quartierBoutique, dateCreation: $dateCreation, idAdmin: $idAdmin, vendeurBoutique: $vendeurBoutique)';
  }

  @override
  bool operator ==(covariant BoutiqueModels other) {
    if (identical(this, other)) return true;

    return other.nomBoutique == nomBoutique &&
        other.villeBoutique == villeBoutique &&
        other.quartierBoutique == quartierBoutique &&
        other.dateCreation == dateCreation &&
        other.idAdmin == idAdmin &&
        other.vendeurBoutique == vendeurBoutique;
  }

  @override
  int get hashCode {
    return nomBoutique.hashCode ^
        villeBoutique.hashCode ^
        quartierBoutique.hashCode ^
        dateCreation.hashCode ^
        idAdmin.hashCode ^
        vendeurBoutique.hashCode;
  }
}
