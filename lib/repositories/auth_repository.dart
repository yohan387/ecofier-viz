import 'dart:convert';

import 'package:ecofier_viz/core/mixins/repositories_mixin.dart';
import 'package:ecofier_viz/core/utils/connection_checker.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/dependencies_injection.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/typedefs.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/core/mixins/rest_api_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository with RestApiMixin, RepositoriesMixin {
  final IConnectionChecker _connectionChecker;

  AuthRepository({required IConnectionChecker connectionChecker})
      : _connectionChecker = connectionChecker;

  ResultFuture<void> registerClient({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
    return executeWithConnectionCheck(
      _connectionChecker,
      () {
        return sendRequest(
          method: ApiMethod.post,
          url: "$apiBaseUrl/register-client",
          body: {
            "nom": firstname,
            "prenoms": lastname,
            "telephone": phoneNumber,
            "mot_de_passe_en_clair": password
          },
          responseHandler: (_) {
            return;
          },
        );
      },
    );
  }

  ResultFuture<User> login(String phoneNumber, String password) async {
    return executeWithConnectionCheck(
      _connectionChecker,
      () async {
        final logedUser = await sendRequest(
          method: ApiMethod.post,
          url: "$apiBaseUrl/login-client",
          body: {
            "telephone": phoneNumber,
            "mot_de_passe_en_clair": password,
          },
          responseHandler: (response) {
            final jsonMap = json.decode(utf8.decode(response));
            return User.fromMap(jsonMap);
          },
        );

        final prefs = sl<SharedPreferences>();

        await prefs.setString('user', json.encode(logedUser.toMap()));

        return logedUser;
      },
    );
  }

  ResultFuture<User> getLocalUser() async {
    return executeWithFailureHandling(
      () async {
        final prefs = sl<SharedPreferences>();
        final userString = prefs.getString('user');
        if (userString != null) {
          final jsonMap = json.decode(userString);
          return User.fromMap(jsonMap);
        }
        throw AppException.localStorage(
          userMessage: "Utilisateur non trouvé.",
          howToResolveError: "Veuillez vous connecter.",
        );
      },
    );
  }

  Future<void> logout() async {
    return Future.delayed(const Duration(seconds: 1));
  }
}
