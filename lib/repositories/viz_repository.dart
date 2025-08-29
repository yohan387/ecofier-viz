import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/dependencies_injection.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';

import 'package:ecofier_viz/core/mixins/repositories_mixin.dart';
import 'package:ecofier_viz/core/mixins/rest_api_mixin.dart';
import 'package:ecofier_viz/core/typedefs.dart';
import 'package:ecofier_viz/core/utils/connection_checker.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:ecofier_viz/models/weighing_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VizRepository with RepositoriesMixin, RestApiMixin {
  final IConnectionChecker _connectionChecker;
  final prefs = sl<SharedPreferences>();
  final _weighings = <Weighing>[];

  VizRepository({required IConnectionChecker connectionChecker})
      : _connectionChecker = connectionChecker;

  ResultFuture<List<Weighing>> getWeighingList() async {
    return executeWithConnectionCheck(_connectionChecker, () async {
      final userString = prefs.getString('user');
      late final String clientId;
      if (userString == null) {
        throw AppException.localStorage(
          userMessage: "Utilisateur non trouvé.",
          howToResolveError: "Veuillez vous connecter.",
        );
      }

      final jsonMap = json.decode(userString);
      clientId = User.fromMap(jsonMap).id;

      return sendRequest(
        method: ApiMethod.get,
        url: "$apiBaseUrl/pesees/client/$clientId",
        responseHandler: (response) {
          final data = json.decode(utf8.decode(response));
          final fetchedWeighings = Weighing.fromMapList(data);
          _weighings
            ..clear()
            ..addAll(fetchedWeighings);

          return _weighings;
        },
      );
    });
  }

  ResultFuture<WeighingSummary> getWeighingSummary() async {
    return Right(WeighingSummary(
      totalWeight: _weighings.fold(0, (sum, w) => sum + (w.poidsNet ?? 0)),
      totalEarned: _weighings.fold(
          0, (sum, w) => sum + getTotalEarned(w.prixProduit, w.poidsNet)),
      totalAnomalies: _weighings.fold(0, (sum, w) => sum + (0)),
      totalItems: _weighings.length,
      lastUpdated: DateTime.now(),
    ));
  }

  double getTotalEarned(double? prixParKilo, double? tolaPoidsNet) {
    if (prixParKilo != null && tolaPoidsNet != null) {
      return prixParKilo * tolaPoidsNet;
    }
    return 0;
  }
}
