// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ams/models/article_model.dart';

class FactureClient {
  final int? index;
  final double? prixTotal;
  final ArticleModels? articleModels;
  final int? quantite;
  final String? idBoutique;
  final double? remise;
  final String? createAt;
  FactureClient({
    this.index,
    this.prixTotal,
    this.articleModels,
    this.quantite,
    this.idBoutique,
    this.remise,
    this.createAt,
  });
  

  FactureClient copyWith({
    int? index,
    double? prixTotal,
    ArticleModels? articleModels,
    int? quantite,
    String? idBoutique,
    double? remise,
    String? createAt,
  }) {
    return FactureClient(
      index: index ?? this.index,
      prixTotal: prixTotal ?? this.prixTotal,
      articleModels: articleModels ?? this.articleModels,
      quantite: quantite ?? this.quantite,
      idBoutique: idBoutique ?? this.idBoutique,
      remise: remise ?? this.remise,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'prixTotal': prixTotal,
      'articleModels': articleModels?.toMap(),
      'quantite': quantite,
      'idBoutique': idBoutique,
      'remise': remise,
      'createAt': createAt,
    };
  }

  factory FactureClient.fromMap(Map<String, dynamic> map) {
    return FactureClient(
      index: map['index'] != null ? map['index'] as int : null,
      prixTotal: map['prixTotal'] != null ? map['prixTotal'] as double : null,
      articleModels: map['articleModels'] != null ? ArticleModels.fromMap(map['articleModels'] as Map<String,dynamic>) : null,
      quantite: map['quantite'] != null ? map['quantite'] as int : null,
      idBoutique: map['idBoutique'] != null ? map['idBoutique'] as String : null,
      remise: map['remise'] != null ? map['remise'] as double : null,
      createAt: map['createAt'] != null ? map['createAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FactureClient.fromJson(String source) => FactureClient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FactureClient(index: $index, prixTotal: $prixTotal, articleModels: $articleModels, quantite: $quantite, idBoutique: $idBoutique, remise: $remise, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant FactureClient other) {
    if (identical(this, other)) return true;
  
    return 
      other.index == index &&
      other.prixTotal == prixTotal &&
      other.articleModels == articleModels &&
      other.quantite == quantite &&
      other.idBoutique == idBoutique &&
      other.remise == remise &&
      other.createAt == createAt;
  }

  @override
  int get hashCode {
    return index.hashCode ^
      prixTotal.hashCode ^
      articleModels.hashCode ^
      quantite.hashCode ^
      idBoutique.hashCode ^
      remise.hashCode ^
      createAt.hashCode;
  }
}
