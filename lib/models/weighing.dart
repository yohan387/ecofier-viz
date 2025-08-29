// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Weighing extends Equatable {
  final String codePesee;
  final DateTime? datePesee1;
  final DateTime? datePesee2;
  final double? poids1;
  final double? poids2;
  final DateTime? heurePesee1;
  final DateTime? heurePesee2;
  final double? poidsNet;
  final double? refraction;
  final double? poidsRefracte;
  final String? mouvement;
  final String? provenance;
  final String? client;
  final String? representant;
  final String? transporteur;
  final String? contenantPesee;
  final String? immatriculation;
  final String? produit;
  final double? prixProduit;
  final String? statutPesee;
  final String? motifAnnulation;
  final String? referencePiece;
  final String clientId;
  final String utilisateurId;

  const Weighing({
    required this.codePesee,
    this.datePesee1,
    this.datePesee2,
    this.poids1,
    this.poids2,
    this.heurePesee1,
    this.heurePesee2,
    this.poidsNet,
    this.refraction,
    this.poidsRefracte,
    this.mouvement,
    this.provenance,
    this.client,
    this.representant,
    this.transporteur,
    this.contenantPesee,
    this.immatriculation,
    this.produit,
    this.prixProduit,
    this.statutPesee,
    this.motifAnnulation,
    this.referencePiece,
    required this.clientId,
    required this.utilisateurId,
  });

  factory Weighing._fromMap(Map<String, dynamic> map) {
    return Weighing(
      codePesee: map['code_pesee'] ?? '',
      datePesee1: map['date_pesee_1'] != null
          ? DateTime.tryParse(map['date_pesee_1'])
          : null,
      datePesee2: map['date_pesee_2'] != null
          ? DateTime.tryParse(map['date_pesee_2'])
          : null,
      poids1: (map['poids_1'] as num?)?.toDouble(),
      poids2: (map['poids_2'] as num?)?.toDouble(),
      heurePesee1: map['heure_pesee_1'] != null
          ? DateTime.tryParse(map['heure_pesee_1'])
          : null,
      heurePesee2: map['heure_pesee_2'] != null
          ? DateTime.tryParse(map['heure_pesee_2'])
          : null,
      poidsNet: (map['poids_net'] as num?)?.toDouble(),
      refraction: (map['refraction'] as num?)?.toDouble(),
      poidsRefracte: (map['poids_refracte'] as num?)?.toDouble(),
      mouvement: map['mouvement'],
      provenance: map['provenance'],
      client: map['client'],
      representant: map['representant'],
      transporteur: map['transporteur'],
      contenantPesee: map['contenant_pesee'],
      immatriculation: map['immatriculation'],
      produit: map['produit'],
      prixProduit: (map['prix_produit'] as num?)?.toDouble(),
      statutPesee: map['statut_pesee'],
      motifAnnulation: map['motif_annulation'],
      referencePiece: map['reference_piece'],
      clientId: map['client_id'] ?? '',
      utilisateurId: map['utilisateur_id'] ?? '',
    );
  }

  /// Conversion d’une liste de JSON → Liste<Weighing>
  static List<Weighing> fromMapList(List<dynamic> list) {
    return list
        .map((e) => Weighing._fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [
        codePesee,
        datePesee1,
        datePesee2,
        poids1,
        poids2,
        heurePesee1,
        heurePesee2,
        poidsNet,
        refraction,
        poidsRefracte,
        mouvement,
        provenance,
        client,
        representant,
        transporteur,
        contenantPesee,
        immatriculation,
        produit,
        prixProduit,
        statutPesee,
        motifAnnulation,
        referencePiece,
        clientId,
        utilisateurId,
      ];

  Weighing copyWith({
    String? codePesee,
    DateTime? datePesee1,
    DateTime? datePesee2,
    double? poids1,
    double? poids2,
    DateTime? heurePesee1,
    DateTime? heurePesee2,
    double? poidsNet,
    double? refraction,
    double? poidsRefracte,
    String? mouvement,
    String? provenance,
    String? client,
    String? representant,
    String? transporteur,
    String? contenantPesee,
    String? immatriculation,
    String? produit,
    double? prixProduit,
    String? statutPesee,
    String? motifAnnulation,
    String? referencePiece,
    String? clientId,
    String? utilisateurId,
  }) {
    return Weighing(
      codePesee: codePesee ?? this.codePesee,
      datePesee1: datePesee1 ?? this.datePesee1,
      datePesee2: datePesee2 ?? this.datePesee2,
      poids1: poids1 ?? this.poids1,
      poids2: poids2 ?? this.poids2,
      heurePesee1: heurePesee1 ?? this.heurePesee1,
      heurePesee2: heurePesee2 ?? this.heurePesee2,
      poidsNet: poidsNet ?? this.poidsNet,
      refraction: refraction ?? this.refraction,
      poidsRefracte: poidsRefracte ?? this.poidsRefracte,
      mouvement: mouvement ?? this.mouvement,
      provenance: provenance ?? this.provenance,
      client: client ?? this.client,
      representant: representant ?? this.representant,
      transporteur: transporteur ?? this.transporteur,
      contenantPesee: contenantPesee ?? this.contenantPesee,
      immatriculation: immatriculation ?? this.immatriculation,
      produit: produit ?? this.produit,
      prixProduit: prixProduit ?? this.prixProduit,
      statutPesee: statutPesee ?? this.statutPesee,
      motifAnnulation: motifAnnulation ?? this.motifAnnulation,
      referencePiece: referencePiece ?? this.referencePiece,
      clientId: clientId ?? this.clientId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
    );
  }
}
