class Membre {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  const Membre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  String get nomComplet => '$nom $postnom $prenom';

  factory Membre.fromJson(Map<String, dynamic> json) {
    return Membre(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      nom: '${json['nom'] ?? ''}',
      postnom: '${json['postnom'] ?? ''}',
      prenom: '${json['prenom'] ?? ''}',
      lieuNaissance: '${json['lieu_naissance'] ?? ''}',
      dateNaissance: '${json['date_naissance'] ?? ''}',
      parente: '${json['parente'] ?? ''}',
      imageUrl: json['image_url'] as String?,
    );
  }

  // Pour POST / PUT en JSON (sans image)
  Map<String, dynamic> toJson() => {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };
}
