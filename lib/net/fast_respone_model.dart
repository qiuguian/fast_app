import 'dart:convert';

class FastResponseModel {
  int code;
  String message;
  String serverMessage;
  dynamic data;

  FastResponseModel({this.code = 0, this.message = '请求成功', this.data});

  /*
  * 请求返回错误
  *
  * */
  factory FastResponseModel.fromError(msg,code,[d]){
    FastResponseModel rep;

    rep = new FastResponseModel()
      ..code = code
      ..data = d
      ..message = msg;

    return rep;
  }

  /*
  * 请求返回成功
  *
  * */
  factory FastResponseModel.fromSuccess(data) => new FastResponseModel()..data = data;

  /*
  * 请求返回单个数组成功
  *
  * */
  factory FastResponseModel.fromSuccessList(data) => new FastResponseModel()..data = data.data;

  /*
  * 参数校验
  *
  * */
  factory FastResponseModel.fromParamError(String msg) => new FastResponseModel()..code=-1..message = '$msg';
}