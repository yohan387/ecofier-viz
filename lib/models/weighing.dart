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
}
