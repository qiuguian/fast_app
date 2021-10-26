import 'dart:convert';

///
/// fast_app_http.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as adio;
import 'package:dio/dio.dart';
import 'package:fast_app/cache/fast_cache.dart';
import 'package:fast_app/net/fast_request.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FastHttpResponse {
  final String body;
  final dynamic data;
  final int? code;
  final Map<String, dynamic> headers;

  FastHttpResponse(this.body, this.code, this.headers, this.data);
}

class FastAppHttp {
  static const int CONNECT_TIMEOUT = 15000;
  static const int RECEIVE_TIMEOUT = 15000;

  static Dio? fastDio;

  /*
  *  初始始化Dio
  * */
  static Dio initDio(
      {required String baseUrl, Interceptor? interceptor, String proxy = ''}) {
    if (fastDio == null) {
      final adio.BaseOptions options = adio.BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        baseUrl: baseUrl,
      );

      final _dio = Dio(options);

      if (interceptor != null) {
        _dio.interceptors.add(interceptor);
      }
      fastDio = _dio;

      if (proxy.isNotEmpty) {
        setProxy(fastDio!, proxyUrl: proxy);
      }
    }
    return fastDio!;
  }

  /*
  * doGet
  *
  * */
  static Future<FastHttpResponse> doGet({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic> headers = const {},
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String? hud,
  }) async {
    adio.BaseOptions options = adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      baseUrl: fastDio?.options.baseUrl ?? '',
    );

    Map? result;
    adio.Dio dio = fastDio ?? adio.Dio(options);
    FastHttpResponse httpResponse;

    //如果要提示加载中之类的hud
    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.Response response = await dio
        .get(
          url,
          options: adio.Options(headers: headers),
          queryParameters: body,
        )
        .whenComplete(() => EasyLoading.dismiss())
        .catchError((e) async {
      DioError error = e;
      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.sendTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.connectTimeout)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doGet(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse = FastHttpResponse(jsonEncode(result), -1, {}, result);
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      }
    });

    if (response.statusCode == HttpStatus.ok) {
      var data = response.data;

      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      result = {
        "code": response.statusCode,
        "msg": response.statusMessage,
        "data": ""
      };
      if (fastDio != null) {
        throw Exception(result); //新版本 兼容旧版本
      }
    }

    httpResponse = FastHttpResponse(jsonEncode(result), response.statusCode,
        result?['headers'] ?? {}, result);

    return httpResponse;
  }

  /*
  * doPost
  *
  * */
  static Future<FastHttpResponse> doPost({
    required String url,
    body,
    Map<String, dynamic> headers = const {},
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String? hud,
  }) async {
    adio.BaseOptions options = adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers.isNotEmpty ? headers['Content-Type'] : "",
    );

    FormData? formData;

    if (headers.isNotEmpty &&
        headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? adio.Dio(options);
    FastHttpResponse httpResponse;

    //如果要提示加载中之类的hud
    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.Response response = await dio
        .post(
          url,
          data: formData ?? body,
        )
        .whenComplete(() => EasyLoading.dismiss())
        .catchError((e) async {
      DioError error = e;

      print('catchError => ${error.message}');

      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.sendTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.connectTimeout)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse = FastHttpResponse(jsonEncode(result), -1, {}, result);
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      }
    });

    if (response.statusCode == HttpStatus.ok) {
      var data = response.data;
      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      result = {
        "msg": "Server busy",
        "code": response.statusCode,
        "msgCode": "1"
      };

      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = FastHttpResponse(
        jsonEncode(result), response.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doPut({
    required String url,
    body,
    Map<String, dynamic> headers = const {},
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String? hud,
  }) async {
    adio.BaseOptions options = adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers.isNotEmpty ? headers['Content-Type'] : "",
    );

    FormData? formData;

    print('request body => ${jsonEncode(body)}');

    if (headers.isNotEmpty &&
        headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? adio.Dio(options);
    late FastHttpResponse httpResponse;

    //如果要提示加载中之类的hud
    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.Response response = await dio
        .put(
          url,
          data: formData ?? body,
        )
        .whenComplete(() => EasyLoading.dismiss())
        .catchError((e) async {
      DioError error = e;

      print('catchError => ${error.message}');

      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.sendTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.connectTimeout)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse = FastHttpResponse(jsonEncode(result), -1, {}, result);
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      }
    });

    if (response.statusCode == HttpStatus.ok) {
      var data = response.data;
      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      print(
          "object response?.statusCoderesponse?.statusCoderesponse?.statusCoderesponse?.statusCode");
      result = {
        "msg": "Server busy",
        "code": response.statusCode,
        "msgCode": "1"
      };
      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = FastHttpResponse(
        jsonEncode(result), response.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doDelete({
    required String url,
    body,
    Map<String, dynamic> headers = const {},
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String? hud,
  }) async {
    adio.BaseOptions options = adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers.isNotEmpty ? headers['Content-Type'] : "",
    );

    FormData? formData;

    print('request body => ${jsonEncode(body)}');

    if (headers.isNotEmpty &&
        headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? adio.Dio(options);
    FastHttpResponse httpResponse;

    //如果要提示加载中之类的hud
    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.Response response = await dio
        .delete(
          url,
          data: formData ?? body,
        )
        .whenComplete(() => EasyLoading.dismiss())
        .catchError((e) async {
      DioError error = e;

      print('catchError => ${error.message}');

      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.sendTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.connectTimeout)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse = FastHttpResponse(jsonEncode(result), -1, {}, result);
        // ignore: invalid_return_type_for_catch_error
        return httpResponse;
      }
    });

    if (response.statusCode == HttpStatus.ok) {
      var data = response.data;
      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      print(
          "object response?.statusCoderesponse?.statusCoderesponse?.statusCoderesponse?.statusCode");
      result = {
        "msg": "Server busy",
        "code": response.statusCode,
        "msgCode": "1"
      };
      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = FastHttpResponse(
        jsonEncode(result), response.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doGetTestData(
      FastRequest request, body, Map<String, String> headers) async {
    late FastHttpResponse httpResponse;

    String data = await loadAsset(request.localTestData()!);

    try {
//      String methodKey = request.url().replaceAll('/', '_');
      String methodKey = request.url();

      Map<String, dynamic> result = jsonDecode(data);

      httpResponse =
          FastHttpResponse(jsonEncode(result[methodKey]), 200, {}, result);
    } catch (e) {
      print('doGetTestData error : ${e.toString()}');
    }

    return httpResponse;
  }

  /*
  * 下载文件
  *
  * */
  Future<Map> downloadFile(String urlPath, String savePath,
      {int localId = 0, cDio, ProgressCallback? onReceiveProgress}) async {
    int _total = 0;
    adio.CancelToken cancelToken = adio.CancelToken();
    try {
      adio.Dio dio = cDio ?? adio.Dio();
      await dio.download(urlPath, savePath, cancelToken: cancelToken,
          onReceiveProgress: (int count, int total) {
        if (onReceiveProgress != null) {
          onReceiveProgress(count, total);
        }

        //进度
        _total = total;
        FastCache('$localId').value = {
          'count': count,
          'total': total,
          'dio': dio,
          'cancelToken': cancelToken
        };
      }).catchError((e) {
        throw e;
      });
      return {'savePath': savePath, 'total': _total};
    } on adio.DioError catch (e) {
      print('downloadFile error---------$e');
      throw e;
    }
  }

  //上传文件
  static Future<FastHttpResponse> upLoadFile({
    required String url,
    required File file,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic>? data, //可选
    String? hud,
    bool isMultiFile = true,
  }) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    Map<String, dynamic> body = Map<String, dynamic>();

    if (data != null) {
      body.addAll(data);
    }

    if (isMultiFile) {
      body.addAll({
        "file": [adio.MultipartFile.fromFileSync(path, filename: name)],
      });
    } else {
      body.addAll({
        "file": adio.MultipartFile.fromFileSync(path, filename: name),
      });
    }

    adio.FormData formData = adio.FormData.fromMap(body);

    var result;

    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.BaseOptions options = adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers.isNotEmpty ? headers['Content-Type'] : null,
    );

    adio.Dio dio = fastDio ?? adio.Dio(options);
    var response = await dio
        .post("$url", data: formData)
        .whenComplete(() => EasyLoading.dismiss());
    if (response.statusCode == HttpStatus.ok) {
      var data = response.data;

      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = response.data;
      }
    } else {
      result = {"msg": "error", "code": response.statusCode, "msgCode": "1"};
    }

    return FastHttpResponse(
        jsonEncode(result), response.statusCode, response.headers.map, result);
  }
}

setProxy(adio.Dio dio, {required String proxyUrl}) {
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.findProxy = (uri) {
      return "PROXY $proxyUrl";
    };

    ///忽略证书
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  };
}

Future<String> loadAsset(String path) async {
//  print('data in root bundle = $path');
  return await rootBundle.loadString(path);
}
