///
/// fast_cache.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

import 'package:flutter/material.dart';
import 'package:fast_app/notice/fast_notification.dart';
import 'dart:async';
import 'package:fast_app/cache/web_cache.dart' if (dart.library.io) 'package:fast_app/cache/app_cache.dart';

typedef Widget StoreBuilder<T>(T item);

final _storeMap = <String, dynamic>{};

class FastCache<T> {
  final String _action;

  const FastCache(this._action);

  T get value => _storeMap[_action];

  set value(T v) {
    if (!(v is List) && !(v is Set) && !(v is Map) && v == _storeMap[_action])
      return;

    _storeMap[_action] = v;

    FastNotification.push('Store::$_action', v);
  }

  clear() => dispose(_action);

  notifyListeners() =>
      FastNotification.push('Store::$_action', _storeMap[_action]);

  static dispose(String action) {
    for (final key in _storeMap.keys.toList(growable: false)) {
      if (key.startsWith(action)) {
        final v = _storeMap.remove(key);

        FastNotification.push('Store::$key', null);
        FastNotification.push('Store::$key::dispose', v);
      }
    }
  }
}

class CacheWidget<T> extends StatefulWidget {
  final String action;
  final StoreBuilder<T> builder;
  final data;

  CacheWidget(this.action, this.builder, {Key key, this.data})
      : super(key: key);

  @override
  _CacheWidgetState createState() => new _CacheWidgetState<T>();
}

class _CacheWidgetState<T> extends State<CacheWidget<T>>
    with FastNotificationStateMixin {
  T item;

  void init() {
    final action = widget.action;

    item = _storeMap[action] as T;

    notice('Store::$action', onData);
  }

  @override
  void initState() {
    super.initState();
    init();
    widget.builder(item);
  }

  @override
  void didUpdateWidget(CacheWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    noticeDel(onData);

    init();
  }

  void onData(_) {
    if (mounted) Timer.run(() => setState(() => item = _));
  }

  @override
  Widget build(BuildContext context) => widget.builder(item);
}

storeString(String k, v) async {
   storeKV(k, v);
}

Future<String> getStoreValue(String k) async {
  return await getStoreByKey(k);
}
