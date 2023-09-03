import 'dart:convert';

class Vendeur {
  final String? id;
  final String? nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String status;
  final String? grade;
  final String? messagingToken;
  final String? createAt;
  final String? idAdmin;

  Vendeur({
    this.id,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
    required this.status,
    this.grade,
    this.messagingToken,
    required this.createAt,
    this.idAdmin,
  });

  Vendeur copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    String? status,
    String? grade,
    String? messagingToken,
    String? createAt,
    String? idAdmin,
  }) {
    return Vendeur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      status: status ?? this.status,
      grade: grade ?? this.grade,
      messagingToken: messagingToken ?? this.messagingToken,
      createAt: createAt ?? this.createAt,
      idAdmin: idAdmin ?? this.idAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'status': status,
      'grade': grade,
      'messagingToken': messagingToken,
      'createAt': createAt,
      'idAdmin': idAdmin,
    };
  }

  factory Vendeur.fromMap(Map<String, dynamic> map) {
    return Vendeur(
      id: map['id'] != null ? map['id'] as String : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      prenom: map['prenom'] != null ? map['prenom'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      status: map['status'] as String,
      grade: map['grade'] != null ? map['grade'] as String : null,
      messagingToken: map['messagingToken'] != null
          ? map['messagingToken'] as String
          : null,
      createAt: map['createAt'] != null ? map['createAt'] as String : null,
      idAdmin: map['idAdmin'] != null ? map['idAdmin'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vendeur.fromJson(String source) =>
      Vendeur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vendeur(id: $id, nom: $nom, prenom: $prenom, telephone: $telephone, email: $email, status: $status, grade: $grade, messagingToken: $messagingToken, idAdmin: $createAt, idAdmin: $createAt)';
  }

  @override
  bool operator ==(covariant Vendeur other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nom == nom &&
        other.prenom == prenom &&
        other.telephone == telephone &&
        other.email == email &&
        other.status == status &&
        other.grade == grade &&
        other.messagingToken == messagingToken &&
        other.idAdmin == idAdmin &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nom.hashCode ^
        prenom.hashCode ^
        telephone.hashCode ^
        email.hashCode ^
        status.hashCode ^
        grade.hashCode ^
        messagingToken.hashCode ^
        createAt.hashCode ^
        idAdmin.hashCode;
  }
}
