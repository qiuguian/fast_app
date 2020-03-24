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
import 'package:fast_app/cache/fast_cache.dart';
import 'package:fast_app/net/fast_request.dart';
import 'package:flutter/services.dart' show rootBundle;

class FastHttpResponse {
  final String body;
  final int code;
  final Map<String,dynamic> headers;

  FastHttpResponse(this.body, this.code, this.headers);
}

class FastAppHttp {
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;

  /*
  * doGet
  *
  * */
  static Future<FastHttpResponse> doGet(
      String url, body, Map<String, dynamic> headers) async {
//    var httpClient = new HttpClient();
//
//    String result;
//    FastHttpResponse httpResponse;
//
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      if (response.statusCode == HttpStatus.ok) {
//        var json = await response.transform(utf8.decoder).join();
//        var data = jsonDecode(json);
//        result = data['origin'];
//      } else {
//        result =
//            'Error getting IP address:\nHttp status ${response.statusCode}';
//      }
//    } catch (exception) {
//      result = 'Failed getting IP address';
//    }
//
//    return httpResponse;

    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
    );

    Map result;
    adio.Dio dio = new adio.Dio(options);
    FastHttpResponse httpResponse;

    try {
      adio.Response response = await dio.get(
        url,
        options: adio.Options(
          headers: headers,
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;

        if (data is String) {
          result = jsonDecode(data);
        } else if (data is Map) {
          result = data;
        }
      } else {
        result = {};
      }
      httpResponse = new FastHttpResponse(
          jsonEncode(result), response.statusCode, result['headers']);
    } on adio.DioError catch (e) {
      print('request.token：' + headers['token']);
      print('request.url：' + url.toString());
      print('request.body：' + jsonEncode(body));
      print('response.error：' + e.toString());
    }

    return httpResponse;
  }

  /*
  * doPost
  *
  * */
  static Future<FastHttpResponse> doPost(
      String url, body, Map<String, dynamic> headers) async {
    var encryptResult = '';

    adio.BaseOptions options = new adio.BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: headers,
      contentType: headers['Content-Type'],
    );

    Map result = {};
    adio.Dio dio = new adio.Dio(options);
    FastHttpResponse httpResponse;

    try {
      adio.Response response = await dio.post(
        url,
        data: body,
//        data: true ? adio.FormData.fromMap(body) : body,
      );

      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;

        if (data is String) {
          result = jsonDecode(data);
        } else if (data is Map) {
          result = data;
        }
      } else {
        result = {"msg":"error","code":response.statusCode,"msgCode":"1"};
      }

      httpResponse = new FastHttpResponse(
          jsonEncode(result), response.statusCode, response.headers.map);
    } on adio.DioError catch (e) {
      print('request.token：' + headers['token']);
      print('request.url：' + url.toString());
      print('request.body：' + jsonEncode(body));
      print('response.error：' + e.toString());
    }

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
  Future<Map> upLoadFile(String url,File file,{Map<String, dynamic> headers}) async {
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
    }else{
      result = {"msg":"error","code":response.statusCode,"msgCode":"1"};
    }

    return result??{};
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
