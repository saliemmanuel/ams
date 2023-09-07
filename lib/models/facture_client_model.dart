// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ams/models/article_modes.dart';

class FactureClient {
  final int? index;
  final double? prixTotal;
  final ArticleModels? articleModels;
  final int? quantite;
  FactureClient({
    this.index,
    this.prixTotal,
    this.articleModels,
    this.quantite,
  });

  // FactureClient(
  //     {this.index, this.prixTotal, this.articleModels, this.quantite});

  // FactureClient.fromJson(Map<String, dynamic> json) {
  //   index = json['index'];
  //   prixTotal = json['prixTotal'];
  //   articleModels = json['articleModels'] != null
  //       ? ArticleModels.fromJson(json['articleModels'])
  //       : null;
  //   quantite = json['quantite'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   data['index'] = index;
  //   data['prixTotal'] = prixTotal;
  //   if (articleModels != null) {
  //     data['articleModels'] = articleModels!.toJson();
  //   }
  //   data['quantite'] = quantite;
  //   return data;
  // }

  FactureClient copyWith({
    int? index,
    double? prixTotal,
    ArticleModels? articleModels,
    int? quantite,
  }) {
    return FactureClient(
      index: index ?? this.index,
      prixTotal: prixTotal ?? this.prixTotal,
      articleModels: articleModels ?? this.articleModels,
      quantite: quantite ?? this.quantite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'prixTotal': prixTotal,
      'articleModels': articleModels?.toMap(),
      'quantite': quantite,
    };
  }

  factory FactureClient.fromMap(Map<String, dynamic> map) {
    return FactureClient(
      index: map['index'] != null ? map['index'] as int : null,
      prixTotal: map['prixTotal'] != null ? map['prixTotal'] as double : null,
      articleModels: map['articleModels'] != null
          ? ArticleModels.fromMap(map['articleModels'] as Map<String, dynamic>)
          : null,
      quantite: map['quantite'] != null ? map['quantite'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FactureClient.fromJson(String source) =>
      FactureClient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FactureClient(index: $index, prixTotal: $prixTotal, articleModels: $articleModels, quantite: $quantite)';
  }

  @override
  bool operator ==(covariant FactureClient other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.prixTotal == prixTotal &&
        other.articleModels == articleModels &&
        other.quantite == quantite;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        prixTotal.hashCode ^
        articleModels.hashCode ^
        quantite.hashCode;
  }
}
