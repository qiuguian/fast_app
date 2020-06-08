import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpStatus, Platform; //Cookie, HttpHeaders

import 'package:fast_app/net/fast_config.dart';
import 'package:fast_app/net/fast_request.dart';
import 'package:fast_app/net/http/fast_app_http.dart';

final timeoutLong = const Duration(seconds: 10);
final timeoutShort = const Duration(seconds: 8);

final _client = new HttpClient();
var _id = 0;

Future<dynamic> api(String url, bool doPost, bool retJson, OnHeaders onHeaders,
    [final obj, Duration cacheTime]) async {
//  Analytics.subEvent('API');

  final id = _id++;
  final httpUrl = obj.apiVersion() != null
      ? '${EnvironmentConfig.share().address}/${obj.apiVersion()}$url'
      : '${EnvironmentConfig.share().address}$url';
  var requstBody;

  if (1 == 2) {
//    Analytics.subEvent('API_无网络');

    await new Future.delayed(
      const Duration(milliseconds: 100),
      () => new Future.error('-1::当前无可用网络::$url-$id'),
    );
  } else {
    String cacheKey;
    FastHttpResponse response;

    if (EnvironmentConfig.share().environment == FastAppEnvironment.local) {
      response = await _client.getTestData(obj);
    } else if (doPost) {
      if (obj is FastRequest) {
        requstBody = jsonDecode(jsonEncode(obj));

        for (final k in requstBody.keys.toList(growable: false)) {
          final v = requstBody[k];
          if (v == null || v == 'null') {
            requstBody.remove(k);
          }
        }

        int timestamp = new DateTime.now().millisecondsSinceEpoch;
      } else {
        requstBody = obj;
      }

      try {
        response = await _client.post(
          httpUrl,
          body: requstBody,
          headers: obj.header(),
        );
      } catch (e) {
        print('HTTP_RESPONSE_TIME::[$id]::${DateTime.now()}');
        print('HTTP_REQUEST_URL::[$id]::$httpUrl');
        print('HTTP_REQUEST_BODY::[$id]::${jsonEncode(requstBody)}');
        return '-1::服务错误::$url-$id';
      }
    } else {
      var query = new StringBuffer('?');

      final map = jsonDecode(jsonEncode(obj));
      if (obj is FastRequest) {
        map.forEach((k, v) {
          if (v == null || v == 'null' || k == 'isFirstPage') return;

          query..write(k)..write('=')..write(v)..write('&');
        });
      } else if (query != null) {
        query.write(obj);
      }

      String urlParam = query.toString();

      if (urlParam.substring(urlParam.length - 1, urlParam.length) == '&') {
        urlParam = urlParam.substring(0, urlParam.length - 1);
      }

      requstBody = urlParam;

      try {
//        response = await _client.get('$httpUrl$query');
        response = await _client.get(
          '$httpUrl$query',
          map,
          headers: obj.header(),
        );
      } catch (e) {
        print('HTTP_RESPONSE_TIME::[$id]::${DateTime.now()}');
        print('HTTP_REQUEST_URL::[$id]::$httpUrl');
        print('HTTP_REQUEST_BODY::[$id]::${jsonEncode(requstBody)}');
        print('server e => ${e.toString()}');
        return '-1::服务错误::$url-$id';
      }
    }

    final statusCode = response.code;

    switch (statusCode) {
      case HttpStatus.ok:
        final body = response.body;

        if (obj.isShowLog()) {
          print('HTTP_RESPONSE_TIME::[$id]::${DateTime.now()}');
          print('HTTP_REQUEST_URL::[$id]::$httpUrl');
          print('HTTP_REQUEST_BODY::[$id]::${jsonEncode(requstBody)}');
          print('HTTP_RESPONSE_BODY::[$id]::${jsonEncode(body)}');
        }

        if (retJson) {
          final json = jsonDecode(body);

          List codes = obj.successCode();

          if (codes.contains(json['${obj.codeKey()}'].toString())) {
            var result;

            if (obj.responseKey() != null) {
              result = json['${obj.responseKey()}'];
            } else {
              result = json;
            }

            var cacheIt = false;

            if (cacheTime != null) {
              if (result is List && result.isNotEmpty) {
                cacheIt = true;
              } else if (result is Map) {
                final _ = result['data'];

                if (_ == null || (_ is List && _.isNotEmpty)) {
                  cacheIt = true;
                }
              }
            }

            if (onHeaders != null) {
              onHeaders(response.headers);
            }

            return result;
          } else if (json['Code'] == 10000102) {
            //登录失效 去重新登录
//            LoginViewModel.loginOut();
          }

          return '${json['code']}::${json['msg']}::$url-$id::${jsonEncode(json['${obj.responseKey()}'])}';
        } else {
          if (obj.isShowLog()) {
            print('HTTP_REQUEST_URL::[$id]::$httpUrl');
            print('HTTP_REQUEST_BODY::[$id]::$requstBody');
            print('HTTP_RESPONSE_BODY::[$id]::$body');
            print('server e => ${body.toString()}');
          }
          return body;
        }
        break;
      default:
        return '$statusCode::服务错误::$url-$id';
    }
  }
}

class HttpClient {
  Future<FastHttpResponse> get(url, body,
      {Map<String, dynamic> headers}) async {
    final response = await FastAppHttp.doGet(url, body, headers);
    return response;
  }

  Future<FastHttpResponse> post(url,
      {Map<String, dynamic> headers, body}) async {
    final response = await FastAppHttp.doPost(url, body, headers);
    return response;
  }

  Future<FastHttpResponse> getTestData(FastRequest request,
      {Map<String, dynamic> headers, body}) async {
    final response = await FastAppHttp.doGetTestData(request, body, headers);
    return response;
  }
}
