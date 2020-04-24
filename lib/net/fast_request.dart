import 'dart:async';
import 'dart:convert';

import 'package:fast_app/net/fast_hud.dart';
import 'package:fast_app/net/fast_respone_model.dart';
import 'package:fast_app/net/fast_view_model.dart';
import 'package:fast_app/net/http/fast_api_request.dart';
import 'package:fast_app/ui/hud/fast_hud_view.dart';
import 'package:flutter/material.dart';

typedef OnData(t);
typedef OnError(String msg, int code);
typedef OnHeaders(headers);

class FastRequest {
  String url() => null;

  bool doPost() => false;

  bool retJson() => true;

  Duration cacheTime() => null;

  String apiVersion() => null;

  bool needLogin() => false;

  bool isShowLog() => false;

  String responseKey() => null;

  String codeKey() => 'code';

  List successCode() => ['200'];

  FastViewModel _viewModel;

  //from-data application/json application/x-www-form-urlencoded
  Map<String, dynamic> header() =>
      <String, dynamic>{"Content-Type": "application/json"};

  String localTestData() => null;

  FastRequest inTarget(FastViewModel viewModel) {
    _viewModel = viewModel;
    return this;
  }

  Future<dynamic> sendApiAction(BuildContext context,
      {hud, OnData onData, OnError onError, OnHeaders onHeaders}) async {
    if (_viewModel != null) {
      _viewModel.start();
    }

    if (context != null && hud != null) {
      FastHudView.show(context, msg: hud);
    }

    var result = await api(this.url(), this.doPost(), this.retJson(), onHeaders,
        this, this.cacheTime());

    if (context != null && hud != null) {
      FastHudView.dismiss();
    }

    if (_viewModel != null) {
      _viewModel.finish();
    }

    if (result is String && result.contains('::')) {

      List data = result.toString().split('::');
      if (data.length == 3) {
        if (onError != null) {
          onError(data[1], int.parse(data[0].toString()));
        }
        throw FastResponseModel.fromError(
            data[1], int.parse(data[0].toString()));
      }
      if (data.length == 4) {
        if (onError != null) {
          onError(data[1], int.parse(data[0].toString()));
        }
        throw FastResponseModel.fromError(data[1],
            int.parse(data[0].toString()), jsonDecode(data[3] ?? '{}'));
      }
    }

    return result;
  }

  sendApi({TaskStatusListener listener, OnData onData, OnError onError}) {
//    this.sendByFuture(
//      api(this.url(), this.doPost(), this.retJson(), this, this.cacheTime()),
//      listener: listener,
//      onData: onData,
//      onError: onError,
//    );
  }

  sendByFuture(
    Future future, {
    TaskStatusListener listener,
    OnData onData,
    OnError onError,
  }) {
    this.send(future, listener: listener, onData: onData, onError: onError);

    return future;
  }

  send(Future observable,
      {TaskStatusListener listener, OnData onData, OnError onError}) {
    final ls = listener ?? EmptyListener();

    ls.onStart();

    observable.then(
      (data) {
        final canCall = () => true && onData != null;
        if (canCall()) Timer.run(() => canCall() ? onData(data) : null);
      },
      onError: (e, s) {
        List data = e.toString().split('::');

        if (data.length != 3) {
          return;
        }
//            errLog(e, s);
        if (onError != null) {
          Timer.run(
            () => onError(data[1], int.parse(data[0].toString())),
          );
        } else if (e is AuthError) {
//          clearLoginInfo();
//          toLogin(context, err);
        }
      },
    )..whenComplete(ls.onFinish);
  }
}

class EmptyListener extends TaskStatusListener {
  @override
  void onFinish() {}

  @override
  void onStart() {}
}

class DefaultStatusListener extends TaskStatusListener {
  final String hud;

  DefaultStatusListener({this.hud});

  @override
  onFinish() {
    FastHud.hidden();
  }

  @override
  onStart() {
    FastHud.show(hud: hud);
  }
}

abstract class TaskStatusListener {
  void onStart();

  void onFinish();
}

class AuthError extends Error {
  @override
  String toString() {
    return '登录状态已失效';
  }
}
