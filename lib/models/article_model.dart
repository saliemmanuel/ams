// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ArticleModels {
  final String? id;
  final String? designation;
  final int? stockActuel;
  final int? stockNormal;
  final int? stockCritique;
  final double? prixAchat;
  final double? prixVente;
  final String? nomBoutique;
  final String? idBoutique;
  final String? codeEnregistrement;
  final String? idAdmin;
  final double? prixNonAuto;
  final String? createAt;
  ArticleModels({
    this.id,
    this.designation,
    this.stockActuel,
    this.stockNormal,
    this.stockCritique,
    this.prixAchat,
    this.prixVente,
    this.nomBoutique,
    this.idBoutique,
    this.codeEnregistrement,
    this.idAdmin,
    this.prixNonAuto,
    this.createAt,
  });

  ArticleModels copyWith({
    String? id,
    String? designation,
    int? stockActuel,
    int? stockNormal,
    int? stockCritique,
    double? prixAchat,
    double? prixVente,
    String? nomBoutique,
    String? idBoutique,
    String? codeEnregistrement,
    String? idAdmin,
    double? prixNonAuto,
    String? createAt,
  }) {
    return ArticleModels(
      id: id ?? this.id,
      designation: designation ?? this.designation,
      stockActuel: stockActuel ?? this.stockActuel,
      stockNormal: stockNormal ?? this.stockNormal,
      stockCritique: stockCritique ?? this.stockCritique,
      prixAchat: prixAchat ?? this.prixAchat,
      prixVente: prixVente ?? this.prixVente,
      nomBoutique: nomBoutique ?? this.nomBoutique,
      idBoutique: idBoutique ?? this.idBoutique,
      codeEnregistrement: codeEnregistrement ?? this.codeEnregistrement,
      idAdmin: idAdmin ?? this.idAdmin,
      prixNonAuto: prixNonAuto ?? this.prixNonAuto,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'designation': designation,
      'stockActuel': stockActuel,
      'stockNormal': stockNormal,
      'stockCritique': stockCritique,
      'prixAchat': prixAchat,
      'prixVente': prixVente,
      'nomBoutique': nomBoutique,
      'idBoutique': idBoutique,
      'codeEnregistrement': codeEnregistrement,
      'idAdmin': idAdmin,
      'prixNonAuto': prixNonAuto,
      'createAt': createAt,
    };
  }

  factory ArticleModels.fromMap(Map<String, dynamic> map) {
    return ArticleModels(
      id: map['id'] != null ? map['id'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
      stockActuel:
          map['stockActuel'] != null ? map['stockActuel'] as int : null,
      stockNormal:
          map['stockNormal'] != null ? map['stockNormal'] as int : null,
      stockCritique:
          map['stockCritique'] != null ? map['stockCritique'] as int : null,
      prixAchat: map['prixAchat'] != null ? map['prixAchat'] as double : null,
      prixVente: map['prixVente'] != null ? map['prixVente'] as double : null,
      nomBoutique:
          map['nomBoutique'] != null ? map['nomBoutique'] as String : null,
      idBoutique:
          map['idBoutique'] != null ? map['idBoutique'] as String : null,
      codeEnregistrement: map['codeEnregistrement'] != null
          ? map['codeEnregistrement'] as String
          : null,
      idAdmin: map['idAdmin'] != null ? map['idAdmin'] as String : null,
      prixNonAuto:
          map['prixNonAuto'] != null ? map['prixNonAuto'] as double : null,
      createAt: map['createAt'] != null ? map['createAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleModels.fromJson(String source) =>
      ArticleModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArticleModels(id: $id, designation: $designation, stockActuel: $stockActuel, stockNormal: $stockNormal, stockCritique: $stockCritique, prixAchat: $prixAchat, prixVente: $prixVente, nomBoutique: $nomBoutique, idBoutique: $idBoutique, codeEnregistrement: $codeEnregistrement, idAdmin: $idAdmin, prixNonAuto: $prixNonAuto, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant ArticleModels other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.designation == designation &&
        other.stockActuel == stockActuel &&
        other.stockNormal == stockNormal &&
        other.stockCritique == stockCritique &&
        other.prixAchat == prixAchat &&
        other.prixVente == prixVente &&
        other.nomBoutique == nomBoutique &&
        other.idBoutique == idBoutique &&
        other.codeEnregistrement == codeEnregistrement &&
        other.idAdmin == idAdmin &&
        other.prixNonAuto == prixNonAuto &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        designation.hashCode ^
        stockActuel.hashCode ^
        stockNormal.hashCode ^
        stockCritique.hashCode ^
        prixAchat.hashCode ^
        prixVente.hashCode ^
        nomBoutique.hashCode ^
        idBoutique.hashCode ^
        codeEnregistrement.hashCode ^
        idAdmin.hashCode ^
        prixNonAuto.hashCode ^
        createAt.hashCode;
  }
}
