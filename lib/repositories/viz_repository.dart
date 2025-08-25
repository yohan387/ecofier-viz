import 'package:ecofier_viz/models/weighing.dart';
import 'package:ecofier_viz/models/weighing_summary.dart';

class VizRepository {
  Future<List<Weighing>> getWeighingList() async {
    // Implementation to fetch the list of weighings
    // This is a placeholder for the actual implementation

    return _mockWeighings;
  }

  Future<Weighing> getWeighingById(String id) async {
    // Implementation to fetch a specific weighing by ID
    // This is a placeholder for the actual implementation
    return _mockWeighings[0];
  }

  Future<WeighingSummary> getWeighingSummary() async {
    // Implementation to fetch the summary of weighings
    // This is a placeholder for the actual implementation
    return WeighingSummary(
      totalWeight: _mockWeighings.fold(0, (sum, w) => sum + (w.poidsNet ?? 0)),
      totalItems: _mockWeighings.length,
      lastUpdated: DateTime.now(),
    );
  }
}

final List<Weighing> _mockWeighings = [
  Weighing(
    codePesee: "PES-001",
    datePesee1: DateTime(2025, 8, 20),
    poids1: 1500.5,
    poidsNet: 1480.0,
    refraction: 2.0,
    poidsRefracte: 1478.0,
    mouvement: "Entrée",
    provenance: "Abidjan",
    client: "Client A",
    representant: "Rep A",
    transporteur: "Transporteur X",
    contenantPesee: "Conteneur 12",
    immatriculation: "AB-123-CD",
    produit: "Cacao",
    prixProduit: 2500.0,
    statutPesee: "Validée",
    referencePiece: "REF-001",
    clientId: "client123",
    utilisateurId: "user123",
  ),
  Weighing(
    codePesee: "PES-002",
    datePesee1: DateTime(2025, 8, 21),
    poids1: 2000.0,
    poidsNet: 1985.0,
    refraction: 1.5,
    poidsRefracte: 1983.5,
    mouvement: "Sortie",
    provenance: "San Pedro",
    client: "Client B",
    representant: "Rep B",
    transporteur: "Transporteur Y",
    contenantPesee: "Camion 45",
    immatriculation: "BC-456-EF",
    produit: "Café",
    prixProduit: 1800.0,
    statutPesee: "En attente",
    referencePiece: "REF-002",
    clientId: "client456",
    utilisateurId: "user456",
  ),
  Weighing(
    codePesee: "PES-003",
    datePesee1: DateTime(2025, 8, 22),
    poids1: 1200.0,
    poidsNet: 1190.0,
    mouvement: "Entrée",
    provenance: "Yamoussoukro",
    client: "Client C",
    representant: "Rep C",
    transporteur: "Transporteur Z",
    contenantPesee: "Sacs",
    immatriculation: "CD-789-GH",
    produit: "Maïs",
    prixProduit: 800.0,
    statutPesee: "Validée",
    referencePiece: "REF-003",
    clientId: "client789",
    utilisateurId: "user789",
  ),
  Weighing(
    codePesee: "PES-004",
    datePesee1: DateTime(2025, 8, 23),
    poids1: 500.0,
    poids2: 480.0,
    poidsNet: 470.0,
    refraction: 0.5,
    poidsRefracte: 469.5,
    mouvement: "Entrée",
    provenance: "Bouaké",
    client: "Client D",
    representant: "Rep D",
    transporteur: "Transporteur W",
    contenantPesee: "Benne",
    immatriculation: "EF-321-IJ",
    produit: "Riz",
    prixProduit: 600.0,
    statutPesee: "Annulée",
    motifAnnulation: "Erreur de saisie",
    referencePiece: "REF-004",
    clientId: "client321",
    utilisateurId: "user321",
  ),
  Weighing(
    codePesee: "PES-005",
    datePesee1: DateTime(2025, 8, 24),
    poids1: 3000.0,
    poids2: 2990.0,
    poidsNet: 2980.0,
    refraction: 3.0,
    poidsRefracte: 2977.0,
    mouvement: "Sortie",
    provenance: "Korhogo",
    client: "Client E",
    representant: "Rep E",
    transporteur: "Transporteur V",
    contenantPesee: "Conteneur 34",
    immatriculation: "GH-654-KL",
    produit: "Coton",
    prixProduit: 2200.0,
    statutPesee: "Validée",
    referencePiece: "REF-005",
    clientId: "client654",
    utilisateurId: "user654",
  ),
];
