import 'dart:convert';

class ArticleModels {
  final String? identifiant;
  final String? designation;
  final int? stockActuel;
  final int? stockNormal;
  final int? stockCritique;
  final double? prixAchat;
  final double? prixVente;
  final String? nomBoutique;
  final String? idBoutique;
  final String? codeEnregistrement;
  final String? createAt;
  ArticleModels({
    this.identifiant,
    this.designation,
    this.stockActuel,
    this.stockNormal,
    this.stockCritique,
    this.prixAchat,
    this.prixVente,
    this.nomBoutique,
    this.idBoutique,
    this.codeEnregistrement,
    this.createAt,
  });

  ArticleModels copyWith({
    String? identifiant,
    String? designation,
    int? stockActuel,
    int? stockNormal,
    int? stockCritique,
    double? prixAchat,
    double? prixVente,
    String? nomBoutique,
    String? idBoutique,
    String? codeEnregistrement,
    String? createAt,
  }) {
    return ArticleModels(
      identifiant: identifiant ?? this.identifiant,
      designation: designation ?? this.designation,
      stockActuel: stockActuel ?? this.stockActuel,
      stockNormal: stockNormal ?? this.stockNormal,
      stockCritique: stockCritique ?? this.stockCritique,
      prixAchat: prixAchat ?? this.prixAchat,
      prixVente: prixVente ?? this.prixVente,
      nomBoutique: nomBoutique ?? this.nomBoutique,
      idBoutique: idBoutique ?? this.idBoutique,
      codeEnregistrement: codeEnregistrement ?? this.codeEnregistrement,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identifiant': identifiant,
      'designation': designation,
      'stockActuel': stockActuel,
      'stockNormal': stockNormal,
      'stockCritique': stockCritique,
      'prixAchat': prixAchat,
      'prixVente': prixVente,
      'nomBoutique': nomBoutique,
      'idBoutique': idBoutique,
      'codeEnregistrement': codeEnregistrement,
      'createAt': createAt,
    };
  }

  factory ArticleModels.fromMap(Map<String, dynamic> map) {
    return ArticleModels(
      identifiant:
          map['identifiant'] != null ? map['identifiant'] as String : null,
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
      createAt: map['createAt'] != null ? map['createAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleModels.fromJson(String source) =>
      ArticleModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArticleModels(identifiant: $identifiant, designation: $designation, stockActuel: $stockActuel, stockNormal: $stockNormal, stockCritique: $stockCritique, prixAchat: $prixAchat, prixVente: $prixVente, nomBoutique: $nomBoutique, idBoutique: $idBoutique, codeEnregistrement: $codeEnregistrement, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant ArticleModels other) {
    if (identical(this, other)) return true;

    return other.identifiant == identifiant &&
        other.designation == designation &&
        other.stockActuel == stockActuel &&
        other.stockNormal == stockNormal &&
        other.stockCritique == stockCritique &&
        other.prixAchat == prixAchat &&
        other.prixVente == prixVente &&
        other.nomBoutique == nomBoutique &&
        other.idBoutique == idBoutique &&
        other.codeEnregistrement == codeEnregistrement &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return identifiant.hashCode ^
        designation.hashCode ^
        stockActuel.hashCode ^
        stockNormal.hashCode ^
        stockCritique.hashCode ^
        prixAchat.hashCode ^
        prixVente.hashCode ^
        nomBoutique.hashCode ^
        idBoutique.hashCode ^
        codeEnregistrement.hashCode ^
        createAt.hashCode;
  }
}
