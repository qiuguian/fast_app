import 'dart:async';

import 'package:fast_app/util/fast_util.dart';
import 'package:flutter/material.dart';

class FastHud {
  static String icon = 'assets/loading.gif';
  static String package = 'fast_app';
  static Timer _timer;
  static int _index = 0;
  static bool isLoading = false;

  ///定时关闭
  static void timerTread([end = 10]) {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
    int index = 0;
    _timer = new Timer.periodic(new Duration(seconds: 1), (Timer timer) {
      index++;
      _index = _index;
      if (index >= end) {
        index = 0;
        dismiss();
      }
    });
  }

  static show({msg = "加载中"}) {
    if (_index > 0) {
      return;
    }

    timerTread();
    isLoading = true;

    showDialog(
        context: navGK.currentContext,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(4.0)),
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
                  width: 90.0,
                  height: 90.0,
                  alignment: Alignment.center,
                  child: new Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: new Image.asset(icon, package: package),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: new Center(
                          child: new Text(
                            msg,
                            style: TextStyle(color: Colors.white),
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  ///取消
  static dismiss() {
    if (isLoading) {
      _timer?.cancel();
      isLoading = false;
      _index = 0;
      Navigator.maybePop(navGK.currentContext);
    }
  }

  ///错误提示语
  static showError({msg}) {
    if (_index > 0 || msg == null) {
      return;
    }

    timerTread(1);
    isLoading = true;

    showDialog(
      context: navGK.currentContext,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(4.0)),
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: new Text(
                    msg,
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
