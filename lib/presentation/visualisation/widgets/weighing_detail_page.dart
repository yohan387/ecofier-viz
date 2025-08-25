import 'package:ecofier_viz/models/weighing.dart';
import 'package:flutter/material.dart';

class WeighingDetailPage extends StatelessWidget {
  final Weighing weighing;

  const WeighingDetailPage({super.key, required this.weighing});

  Widget _buildDetailItem(String label, String? value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? "Non renseigné"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesée : ${weighing.codePesee}"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetailItem("Code pesée", weighing.codePesee),
          _buildDetailItem(
              "Date pesée 1", weighing.datePesee1?.toIso8601String()),
          _buildDetailItem("Poids 1", weighing.poids1?.toStringAsFixed(2)),
          _buildDetailItem("Poids 2", weighing.poids2?.toStringAsFixed(2)),
          _buildDetailItem("Poids net", weighing.poidsNet?.toStringAsFixed(2)),
          _buildDetailItem(
              "Réfraction", weighing.refraction?.toStringAsFixed(2)),
          _buildDetailItem(
              "Poids réfracté", weighing.poidsRefracte?.toStringAsFixed(2)),
          _buildDetailItem("Mouvement", weighing.mouvement),
          _buildDetailItem("Provenance", weighing.provenance),
          _buildDetailItem("Client", weighing.client),
          _buildDetailItem("Représentant", weighing.representant),
          _buildDetailItem("Transporteur", weighing.transporteur),
          _buildDetailItem("Contenant", weighing.contenantPesee),
          _buildDetailItem("Immatriculation", weighing.immatriculation),
          _buildDetailItem("Produit", weighing.produit),
          _buildDetailItem(
              "Prix produit", weighing.prixProduit?.toStringAsFixed(2)),
          _buildDetailItem("Statut pesée", weighing.statutPesee),
          _buildDetailItem("Motif annulation", weighing.motifAnnulation),
          _buildDetailItem("Référence pièce", weighing.referencePiece),
          _buildDetailItem("Client ID", weighing.clientId),
          _buildDetailItem("Utilisateur ID", weighing.utilisateurId),
        ],
      ),
    );
  }
}
