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
  final int code;
  final Map<String, dynamic> headers;

  FastHttpResponse(this.body, this.code, this.headers, this.data);
}

class FastAppHttp {
  static const int CONNECT_TIMEOUT = 15000;
  static const int RECEIVE_TIMEOUT = 15000;

  static Dio fastDio;

  /*
  *  初始始化Dio
  * */
  static Dio initDio({String baseUrl, Interceptor interceptor,String proxy = ''}) {
    if (fastDio == null) {
      final adio.BaseOptions options = new adio.BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        baseUrl: baseUrl,
      );

      final _dio = Dio(options);

      if (interceptor != null) {
        _dio.interceptors.add(interceptor);
      }
      fastDio = _dio;

      if(proxy.isNotEmpty){
        setProxy(fastDio,proxyUrl:proxy);
      }

    }
    return fastDio;
  }

  /*
  * doGet
  *
  * */
  static Future<FastHttpResponse> doGet({
    String url,
    body,
    Map<String, dynamic> headers,
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String hud,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
    );

    Map result;
    adio.Dio dio = fastDio ?? new adio.Dio(options);
    FastHttpResponse httpResponse;

    //如果要提示加载中之类的hud
    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.Response response = await dio
        .get(
      url,
      options: adio.Options(
        headers: headers,
      ),
    )
        .whenComplete(() => EasyLoading.dismiss())
        .catchError((e) async {
      DioError error = e;
      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doGet(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse =
        new FastHttpResponse(jsonEncode(result), -1, null, result);
        return httpResponse;
      }
    });

    if (response?.statusCode == HttpStatus.ok) {
      var data = response.data;

      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      result = {
        "code": response?.statusCode,
        "msg": response.statusMessage,
        "data": ""
      };
      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }

    httpResponse = new FastHttpResponse(
        jsonEncode(result), response?.statusCode, result['headers'], result);

    return httpResponse;
  }

  /*
  * doPost
  *
  * */
  static Future<FastHttpResponse> doPost({
    String url,
    body,
    Map<String, dynamic> headers,
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String hud,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers != null ? headers['Content-Type'] : "",
    );

    FormData formData;

    if (headers != null && headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? new adio.Dio(options);
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
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse =
        new FastHttpResponse(jsonEncode(result), -1, null, result);
        return httpResponse;
      }
    });

    if (response?.statusCode == HttpStatus.ok) {
      var data = response.data;
      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = data;
      }
    } else {
      result = {
        "msg": "Server busy",
        "code": response?.statusCode,
        "msgCode": "1"
      };

      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = new FastHttpResponse(
        jsonEncode(result), response?.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doPut({
    String url,
    body,
    Map<String, dynamic> headers,
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String hud,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers != null ? headers['Content-Type'] : "",
    );

    FormData formData;

    print('request body => ${jsonEncode(body)}');

    if (headers != null && headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? new adio.Dio(options);
    FastHttpResponse httpResponse;

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
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse =
        new FastHttpResponse(jsonEncode(result), -1, null, result);
        return httpResponse;
      }
    });

    if (response?.statusCode == HttpStatus.ok) {
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
        "code": response?.statusCode,
        "msgCode": "1"
      };
      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = new FastHttpResponse(
        jsonEncode(result), response?.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doDelete({
    String url,
    body,
    Map<String, dynamic> headers,
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
    String hud,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers != null ? headers['Content-Type'] : "",
    );

    FormData formData;

    print('request body => ${jsonEncode(body)}');

    if (headers != null && headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = fastDio ?? new adio.Dio(options);
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
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url: url,
          body: body,
          headers: headers,
          isReconnectStrategyStart: isReconnectStrategyStart,
          reconnectTime: reconnectTime--,
        );
        return httpResponse;
      } else {
        result = {
          "msg": "Server busy,please try again later",
          "code": -1,
          "msgCode": "1"
        };
        httpResponse =
        new FastHttpResponse(jsonEncode(result), -1, null, result);
        return httpResponse;
      }
    });

    if (response?.statusCode == HttpStatus.ok) {
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
        "code": response?.statusCode,
        "msgCode": "1"
      };
      if (fastDio != null) {
        throw result; //新版本 兼容旧版本
      }
    }
    httpResponse = new FastHttpResponse(
        jsonEncode(result), response?.statusCode, response.headers.map, result);

    return httpResponse;
  }

  static Future<FastHttpResponse> doGetTestData(FastRequest request, body,
      Map<String, String> headers) async {
    FastHttpResponse httpResponse;

    String data = await loadAsset(request.localTestData());

    try {
//      String methodKey = request.url().replaceAll('/', '_');
      String methodKey = request.url();

      Map<String, dynamic> result = jsonDecode(data);

      httpResponse = new FastHttpResponse(
          jsonEncode(result[methodKey]), 200, null, result);
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
      {int localId = 0, cDio, ProgressCallback onReceiveProgress}) async {
    adio.Response response;
    int _total = 0;
    adio.CancelToken cancelToken = new adio.CancelToken();
    try {
      adio.Dio dio = cDio ?? new adio.Dio();
      response = await dio.download(urlPath, savePath, cancelToken: cancelToken,
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
    String url,
    File file,
    Map<String, dynamic> headers,
    Map<String, dynamic> data, //可选
    String hud,
    bool isMultiFile = true,
  }) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    Map<String, dynamic> body = new Map<String, dynamic>();

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

    adio.FormData formData = new adio.FormData.fromMap(body);

    var result;

    if (hud != null && hud.isNotEmpty) {
      EasyLoading.show(status: hud);
    }

    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers != null ? headers['Content-Type'] : null,
    );

    adio.Dio dio = fastDio ?? new adio.Dio(options);
    var response = await dio
        .post("$url", data: formData)
        .whenComplete(() => EasyLoading.dismiss());
    if (response?.statusCode == HttpStatus.ok) {
      var data = response.data;

      if (data is String) {
        result = jsonDecode(data);
      } else if (data is Map) {
        result = response.data;
      }
    } else {
      result = {"msg": "error", "code": response?.statusCode, "msgCode": "1"};
    }

    return new FastHttpResponse(
        jsonEncode(result), response?.statusCode, response.headers.map, result);
  }
}

setProxy(adio.Dio dio,{String proxyUrl}) {
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
