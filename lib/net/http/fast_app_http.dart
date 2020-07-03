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

import 'package:dio/dio.dart' as adio;
import 'package:dio/dio.dart';
import 'package:fast_app/cache/fast_cache.dart';
import 'package:fast_app/net/fast_request.dart';
import 'package:flutter/services.dart' show rootBundle;

class FastHttpResponse {
  final String body;
  final int code;
  final Map<String, dynamic> headers;

  FastHttpResponse(this.body, this.code, this.headers);
}

class FastAppHttp {
  static const int CONNECT_TIMEOUT = 15000;
  static const int RECEIVE_TIMEOUT = 15000;

  /*
  * doGet
  *
  * */
  static Future<FastHttpResponse> doGet(
    String url,
    body,
    Map<String, dynamic> headers, {
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
    );

    Map result;
    adio.Dio dio = new adio.Dio(options);
    FastHttpResponse httpResponse;

    adio.Response response = await dio
        .get(
      url,
      options: adio.Options(
        headers: headers,
      ),
    )
        .catchError((e) async {
      DioError error = e;

      print('catchError => ${error.message}');

      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doGet(
          url,
          body,
          headers,
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
        httpResponse = new FastHttpResponse(jsonEncode(result), -1, null);
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
    }

    httpResponse = new FastHttpResponse(
        jsonEncode(result), response.statusCode, result['headers']);

    return httpResponse;
  }

  /*
  * doPost
  *
  * */
  static Future<FastHttpResponse> doPost(
    String url,
    body,
    Map<String, dynamic> headers, {
    bool isReconnectStrategyStart = false,
    int reconnectTime = 0,
  }) async {
    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers['Content-Type'],
    );

    FormData formData;

    if (headers['Content-Type'] == "application/formData") {
      formData = FormData.fromMap(body);
    }

    Map result = {};
    adio.Dio dio = new adio.Dio(options);
    FastHttpResponse httpResponse;

    adio.Response response = await dio
        .post(
      url,
      data: formData ?? body,
    )
        .whenComplete(() {
//      print('whenComplete=>$url');
    }).catchError((e) async {
      DioError error = e;

      print('catchError => ${error.message}');

      if (reconnectTime > 0 &&
          isReconnectStrategyStart &&
          (error.type == DioErrorType.SEND_TIMEOUT ||
              error.type == DioErrorType.RECEIVE_TIMEOUT ||
              error.type == DioErrorType.CONNECT_TIMEOUT)) {
        print('start reconnect reconnectTime left: $reconnectTime');
        httpResponse = await doPost(
          url,
          body,
          headers,
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
        httpResponse = new FastHttpResponse(jsonEncode(result), -1, null);
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
    }

    httpResponse = new FastHttpResponse(
        jsonEncode(result), response.statusCode, response.headers.map);

    return httpResponse;
  }

  static Future<FastHttpResponse> doGetTestData(
      FastRequest request, body, Map<String, String> headers) async {
    FastHttpResponse httpResponse;

    String data = await loadAsset(request.localTestData());

    try {
//      String methodKey = request.url().replaceAll('/', '_');
      String methodKey = request.url();

      Map<String, dynamic> result = jsonDecode(data);

      httpResponse =
          new FastHttpResponse(jsonEncode(result[methodKey]), 200, null);
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
      {int localId = 0, cDio}) async {
    adio.Response response;
    int _total = 0;
    adio.CancelToken cancelToken = new adio.CancelToken();
    try {
      adio.Dio dio = cDio ?? new adio.Dio();
      response = await dio.download(urlPath, savePath, cancelToken: cancelToken,
          onReceiveProgress: (int count, int total) {
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

  //上传图片
  Future<Map> upLoadFile(String url, File file,
      {Map<String, dynamic> headers}) async {
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    adio.FormData formData = new adio.FormData.fromMap({
      "file": [adio.MultipartFile.fromFileSync(path, filename: name)],
    });

    var result;

    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers != null ? headers['Content-Type'] : null,
    );

    adio.Dio dio = new adio.Dio(options);
    var response = await dio.post("$url", data: formData);
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

    return result ?? {};
  }
}

proxy(adio.Dio dio) {
//  (dio.httpClientAdapter as adio.DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//    client.findProxy = (uri) {
//      return "PROXY $proxyUrl";
//    };
//  };
}

Future<String> loadAsset(String path) async {
//  print('data in root bundle = $path');
  return await rootBundle.loadString(path);
}
