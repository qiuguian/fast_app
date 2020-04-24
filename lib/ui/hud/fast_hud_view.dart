import 'dart:async';

import 'package:flutter/material.dart';

class FastHudView {
  static bool isLoading = false;
  static bool isAutoShow = false;
  static OverlayEntry overlayEntry;
  static BuildContext _context;
  static Timer _timer;
  static String icon = 'assets/loading.gif';
  static String package = 'fast_app';

  ///定时关闭
  static void timerTread() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
    int index = 0;
    _timer = new Timer.periodic(new Duration(seconds: 1), (Timer timer) {
      index++;
      if (index >= 10) {
        index = 0;
        timer.cancel();
        dismiss();
      }
    });
  }

  static void show(BuildContext context, {msg = '加载中...'}) {

    if (context == null) {
      return;
    }

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      dismiss();

      if (isLoading) {
        return;
      }
      isLoading = true;
      isAutoShow = false;
      _context = context;

      timerTread();

      overlayEntry = new OverlayEntry(
        builder: (context) {
          return new Center(
            child: new Material(
              type: MaterialType.transparency,
              textStyle: new TextStyle(color: const Color(0xFF212121)),
              child: new Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
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
              ),
            ),
          );
        },
      );

      if (overlayEntry != null && _context != null) {
        _context?.findAncestorStateOfType();
//        Overlay.of(_context).insert(overlayEntry);
      }
    });
  }

  static void dismiss() {
    if (isLoading && overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    isLoading = false;
    isAutoShow = false;
  }

  static void autoShow(BuildContext context, {msg = '加载中...'}) {
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      dismiss();

      isLoading = true;
      isAutoShow = true;
      _context = context;

      timerTread();

      if (overlayEntry == null) {
        overlayEntry = new OverlayEntry(
          builder: (context) {
            return new Center(
              child: new Material(
                type: MaterialType.transparency,
                textStyle: new TextStyle(color: const Color(0xFF212121)),
                child: new Container(
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
                ),
              ),
            );
          },
        );
      }

      Overlay.of(_context).insert(overlayEntry);
    });
  }

  static void autoDismiss() {
    if (isAutoShow) {
      if (isLoading && overlayEntry != null) {
        overlayEntry.remove();
        overlayEntry = null;
      }
      isLoading = false;
    } else {
      isAutoShow = false;
    }
  }
}
