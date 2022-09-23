import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

import 'package:fui_lib/fui_lib.dart';

enum HttpMethod { delete, get, patch, post }

extension HttpMethodValueExtension on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.post:
        return 'POST';
      default:
        throw Exception('ERROR: HttpMethod is invalid, with value: $this');
    }
  }
}

class Lip extends http.BaseClient {
  Lip(this.king, {this.pool}) {
    timeout = king.conf.requestTimeout;
    pool?.checkAddresses();
  }

  King king;
  final http.Client _inner = http.Client();
  final AddressPool? pool;
  int timeout = 10;

  Future<ApiResponse> api(
    String path, {
    HttpMethod method = HttpMethod.post,
    Map<String, dynamic> payload = const {},
    String origin = '',
    bool usePathRoot = true,
  }) async {
    bool wasPrepError = false;
    Uri uri = Uri();

    king.log.d('about to try Uri');
    if (pool != null) {
      Uri? tryUri = pool?.makeUri(path, usePathRoot: usePathRoot);
      king.log.d('$tryUri');

      int attempt = 1;
      while (tryUri == null) {
        king.log.w('LIP try $attempt: No API url for request to $path');
        await Future.delayed(const Duration(milliseconds: 2000));
        pool?.checkAddresses();
        tryUri = pool?.makeUri(path, usePathRoot: usePathRoot);
        attempt++;

        if (attempt == 2) {
          king.snacker.addSnack(Snacks.networkError);
          wasPrepError = true;
          break;
        }
      }

      uri = tryUri ?? Uri();
    } else {
      uri = Uri.parse('$origin/$path');
    }

    var uuid = const Uuid();
    Map<String, String> headers = {
      'content-type': 'application/json',
      'UfId': uuid.v1(),
    };
    king.todd.attachSessionHeaders(headers);

    king.log.d('request to tryUri $path');
    var ares = await makeRequest(
      headers: headers,
      method: method,
      payload: payload,
      uri: uri,
      wasPrepError: wasPrepError,
    );

    return ares;
  }

  Future<ApiResponse> stripe(
    String path, {
    HttpMethod method = HttpMethod.post,
    Map<String, dynamic> params = const {},
    Map<String, dynamic> payload = const {},
  }) async {
    var uri = Uri(
      scheme: 'https',
      host: 'api.stripe.com',
      path: 'v1$path',
      queryParameters: params,
    );

    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${king.conf.stripePublishableKey}',
    };

    var ares = await makeRequest(
      headers: headers,
      method: method,
      payload: {},
      uri: uri,
    );

    return ares;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  Future<ApiResponse> makeRequest({
    required Map<String, String> headers,
    required HttpMethod method,
    required Map<String, dynamic> payload,
    required Uri uri,
    bool wasPrepError = false,
  }) async {
    ApiResponse ares = ApiResponse();
    String payloadAsString = jsonEncode(payload);
    if (wasPrepError) {
      ares.errored = wasPrepError;
    } else {
      try {
        try {
          http.Response response;
          switch (method) {
            case HttpMethod.get:
              response = await _inner
                  .get(uri, headers: headers)
                  .timeout(Duration(seconds: timeout));
              break;

            case HttpMethod.patch:
              response = await _inner
                  .patch(uri,
                      headers: headers,
                      body: payloadAsString,
                      encoding: Encoding.getByName('utf-8'))
                  .timeout(Duration(seconds: timeout));
              break;

            case HttpMethod.post:
              response = await _inner
                  .post(uri,
                      headers: headers,
                      body: payloadAsString,
                      encoding: Encoding.getByName('utf-8'))
                  .timeout(Duration(seconds: timeout));
              break;

            case HttpMethod.delete:
              response = await _inner
                  .delete(uri, headers: headers)
                  .timeout(Duration(seconds: timeout));
              break;
          }

          ares.processHttpResponse(response, king);
        } on SocketException catch (e, s) {
          print(e);
          print(s);
          king.log.i('ERROR: SocketException while connecting to API');
          ares.errored = true;
        } on TimeoutException catch (e, s) {
          print(e);
          print(s);
          king.log.i('ERROR: TimeoutException while connecting to API');
          ares.errored = true;
        } catch (e, s) {
          print(e);
          print(s);
          king.log.i('ERROR: Unknown exception while connecting to API');
          ares.errored = true;
          rethrow;
        }
      } catch (e, s) {
        print(e);
        print(s);
        ares.errored = true;
        king.snacker.addSnack(Snacks.networkError);
      }
    }

    king.log.v([
      '${method.value}${method.value}${method.value}${method.value}${method.value}${method.value}${method.value}${method.value}',
      'WWWAPI: ${method.value} request to +$uri+ with fields:',
      'Headers: $headers',
      'Payload: $payloadAsString',
      //print('Response headers: ${response.headers['content-type']}',
      'Response status code: ${ares.statusCode}',
      'Response body: ${ares.body}',
      'Is response Ok?: ${ares.isOk}',
    ].join('\n'));

    return ares;
  }
}

class ApiResponse {
  int statusCode = 0;
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  bool errored = false;
  List<ApiError> errors = [];

  void processHttpResponse(http.Response response, King king) {
    statusCode = response.statusCode;
    headers = response.headers;
    String contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      try {
        body = json.decode(response.body);
      } on FormatException catch (e, s) {
        king.log.i('FormatException while reading API response');
        print(e);
        print(s);
      }

      if (body.containsKey('Errors')) {
        for (Map<String, dynamic> errj in body['Errors']) {
          final error =
              ApiError(readString(errj, 'Code'), readString(errj, 'Msg'));
          errors.add(error);
        }
        errored = true;
      }
    }

    if (statusCode == 444) {
      king.todd.refreshJwt();
    }

    if ((statusCode < 200) || (statusCode > 299)) {
      king.log.v('status code out of range');
      errored = true;
    }
  }

  bool get isOk {
    return !isNotOk;
  }

  bool get isNotOk {
    return errored || errors.isNotEmpty;
  }

  @override
  String toString() {
    return '$statusCode $headers $body $errored';
  }

  bool get hasErrorMsg {
    if (errors.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool hasErrorCode(String code) {
    for (final error in errors) {
      if (code == error.code) {
        return true;
      }
    }
    return false;
  }

  bool hasOneOfErrorCodes(List<String> codes) {
    for (final error in errors) {
      if (codes.contains(error.code)) {
        return true;
      }
    }
    return false;
  }

  String errorMsgFromCode(String code) {
    for (final error in errors) {
      if (error.code == code) {
        return error.msg;
      }
    }
    return 'Unhandled error. Try again or contact support.';
  }

  String get firstErrorMsg {
    if (errors.isEmpty) {
      return 'Unhandled error. Try again or contact support.';
    } else {
      return errors[0].msg;
    }
  }

  String peekErrorMsg({String defaultText = 'Failed.'}) {
    if (errors.isEmpty) {
      return defaultText;
    } else {
      return firstErrorMsg;
    }
  }
}

class ApiError {
  const ApiError(this.code, this.msg);
  final String code;
  final String msg;
}
