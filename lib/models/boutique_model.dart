import 'dart:convert';

class BoutiqueModels {
  String? id;
  String? dateCreation;
  String? idAdmin;
  String? nomBoutique;
  String? quartierBoutique;
  String? villeBoutique;
  List<String>? vendeur;

  BoutiqueModels(
      {this.id,
      this.dateCreation,
      this.idAdmin,
      this.nomBoutique,
      this.quartierBoutique,
      this.villeBoutique,
      this.vendeur});

  BoutiqueModels.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    dateCreation = json['dateCreation'];
    idAdmin = json['idAdmin'];
    nomBoutique = json['nomBoutique'];
    quartierBoutique = json['quartierBoutique'];
    villeBoutique = json['villeBoutique'];
    vendeur = json['vendeur'].cast<String>();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['dateCreation'] = dateCreation;
    data['idAdmin'] = idAdmin;
    data['nomBoutique'] = nomBoutique;
    data['quartierBoutique'] = quartierBoutique;
    data['villeBoutique'] = villeBoutique;
    data['vendeur'] = vendeur;
    return data;
  }

  addVendeur(String newVendeur) {
    vendeur!.add(newVendeur);
  }

  removeVendeur(String newVendeur) {
    vendeur!.remove(newVendeur);
  }

  @override
  String toString() {
    return 'BoutiqueModels(id: $id, nomBoutique: $nomBoutique, villeBoutique: $villeBoutique, quartierBoutique: $quartierBoutique, dateCreation: $dateCreation, idAdmin: $idAdmin, vendeurBoutique: $vendeur)';
  }

  String toJson() => json.encode(toMap());

  factory BoutiqueModels.fromJson(String source) =>
      BoutiqueModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
