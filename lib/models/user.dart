// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Users {
  final String? id;
  final String? nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String status;
  final String? grade;
  final String? createAt;
  String? messagingToken;
  Users({
    this.id,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
    required this.status,
    this.grade,
    required this.createAt,
    this.messagingToken,
  });
  set messagingsToken(String? token) {
    messagingToken = token;
  }

  Users copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    String? status,
    String? grade,
    String? createAt,
    String? messagingToken,
  }) {
    return Users(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      status: status ?? this.status,
      createAt: createAt ?? this.createAt,
      grade: grade ?? this.grade,
      messagingToken: messagingToken ?? this.messagingToken,
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
      'createAt': createAt,
      'messagingToken': messagingToken,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] != null ? map['id'] as String : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      prenom: map['prenom'] != null ? map['prenom'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      status: map['status'] as String,
      grade: map['grade'] != null ? map['grade'] as String : null,
      createAt: map['createAt'] != null ? map['createAt'] as String : null,
      messagingToken: map['messagingToken'] != null
          ? map['messagingToken'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Users(id: $id, nom: $nom, prenom: $prenom, telephone: $telephone, email: $email, status: $status, grade: $grade,  createAt: $createAt, messagingToken: $messagingToken)';
  }

  @override
  bool operator ==(covariant Users other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nom == nom &&
        other.prenom == prenom &&
        other.telephone == telephone &&
        other.email == email &&
        other.status == status &&
        other.createAt == createAt &&
        other.grade == grade &&
        other.messagingToken == messagingToken;
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
        createAt.hashCode ^
        messagingToken.hashCode;
  }
}
