import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/dependencies_injection.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

mixin RestApiMixin {
  final http.Client _httpClient = sl<http.Client>();

  Future<T> sendRequest<T>({
    required ApiMethod method,
    required String url,
    Map<String, dynamic>? body,
    required T Function(Uint8List) responseHandler,
    Map<String, String>? additionnalHeaders,
    Duration timeoutDuration = const Duration(minutes: 10),
  }) async {
    return _executeRemoteCall(
      () async {
        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          if (additionnalHeaders != null) ...additionnalHeaders
        };
        final requestUrl = Uri.parse(url);
        late http.Response response;
        switch (method) {
          case ApiMethod.post:
            response = await _httpClient.post(
              requestUrl,
              headers: headers,
              body: jsonEncode(body),
            );
            break;
          case ApiMethod.get:
            response = await _httpClient.get(
              requestUrl,
              headers: headers,
            );
            break;
          case ApiMethod.put:
            response = await _httpClient.put(
              requestUrl,
              headers: headers,
              body: jsonEncode(body),
            );
            break;
          case ApiMethod.delete:
            response = await _httpClient.delete(
              requestUrl,
              headers: headers,
            );
            break;
          default:
            throw UnsupportedError(
              'Méthode HTTP non prise en charge : $method',
            );
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          return responseHandler(response.bodyBytes);
        } else if (response.statusCode == 401) {
          final Map<String, dynamic> body =
              json.decode(utf8.decode(response.bodyBytes));
          throw AppException.api(
            statusCode: AppErrorStatusCode.api,
            userMessage: body['detail'] ?? "Non autorisé.",
            description: response.body.toString(),
            howToResolveError:
                "Veuillez vous déconnecter et vous reconnecter à nouveau. Si le problème persiste, veuillez contacter le service client.",
          );
        } else if (response.statusCode == 400 || response.statusCode == 403) {
          throw AppException.api(
            statusCode: AppErrorStatusCode.invalideToken,
            userMessage: "Accès non autorisé.",
            description: response.body.toString(),
            howToResolveError:
                "Veuillez vous déconnecter et vous reconnecter à nouveau. Si le problème persiste, veuillez contacter le service client.",
          );
        } else {
          throw AppException.api(
            userMessage: "Serveur indisponible.",
            description: response.body.toString(),
            howToResolveError: "Veuillez réessayer ultérieurement.",
          );
        }
      },
    );
  }

  Future<T> _executeRemoteCall<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      if (e is TimeoutException) {
        throw AppException.api(
          statusCode: AppErrorStatusCode.api,
          userMessage: "Délai d'attente expiré.",
          description: e.toString(),
          howToResolveError: "Veuillez réessayer ultérieurement.",
        );
      } else if (e is SocketException) {
        throw AppException.api(
          statusCode: AppErrorStatusCode.socket,
          userMessage: "La communication avec le serveur a échoué.",
          description: e.toString(),
          howToResolveError: "Veuillez réessayer ultérieurement.",
        );
      } else if (e is AppException) {
        rethrow;
      } else {
        throw AppException.internal(
          description: e.toString(),
        );
      }
    }
  }
}
