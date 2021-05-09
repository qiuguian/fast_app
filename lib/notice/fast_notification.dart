///
/// fast_notification.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

import 'package:flutter/material.dart';

typedef Callback(data);

class FastNotification {
  FastNotification._();

  static final _eventMap = <String, List<Callback>>{};

  static Callback addListener(String event, Callback call) {
    var callList = _eventMap[event];
    if (callList == null) {
      callList = [];
      _eventMap[event] = callList;
    }

    callList.add(call);

    return call;
  }

  static removeListenerByEvent(String event) {
    _eventMap.remove(event);
  }

  static removeListener(Callback call) {
    final keys = _eventMap.keys.toList(growable: false);
    for (final k in keys) {
      final v = _eventMap[k];

      final remove = v?.remove(call);
      if (remove != null && remove && v!.isEmpty) {
        _eventMap.remove(k);
      }
    }
  }

  static once(String event, {data}) {
    final callList = _eventMap[event];

    if (callList != null) {
      for (final item in new List.from(callList, growable: false)) {
        removeListener(item);

        _errorWrap(event, item, data);
      }
    }
  }

  static push(String event, [data]) {
    var callList = _eventMap[event];

    if (callList != null) {
      for (final item in callList) {
        _errorWrap(event, item, data);
      }
    }
  }

  static _errorWrap(String event, Callback call, data) {
    try {
      call(data);
    } catch (e) {}
  }
}

mixin FastNotificationStateMixin<T extends StatefulWidget> on State<T> {
  List<Callback> _listeners = [];

  void notice(String event, Callback call) {
    _listeners.add(FastNotification.addListener(event, call));
  }

  void noticeDel(Callback call) {
    if (_listeners.remove(call)) {
      FastNotification.removeListener(call);
    }
  }

  void noticeDelAll() {
    _listeners.forEach(FastNotification.removeListener);
    _listeners.clear();
  }

  @override
  void dispose() {
    noticeDelAll();
    super.dispose();
  }
}
