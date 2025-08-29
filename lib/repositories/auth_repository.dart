import 'dart:convert';

import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/dependencies_injection.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/core/base_services_mixin/rest_api_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository with ApiMixin {
  Future<void> registerClient({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
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
  }

  Future<User> login(String phoneNumber, String password) async {
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
  }

  Future<void> logout() async {
    return Future.delayed(const Duration(seconds: 1));
  }
}
