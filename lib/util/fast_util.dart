///
/// fast_util.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

library fast_util;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

part 'param_util.dart';

final navGK = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> scaffoldGK = GlobalKey<ScaffoldState>();

Future<T?>? fastRoutePush<T extends Object?>(Widget widget) {
  Route<T> route = CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: RouteSettings(
      name: '/${widget.toStringShort()}',
//      isInitialRoute: false,
    ),
  );
  return navGK.currentState?.push<T>(route);
}

Future<T?>? routeReplace<T extends Object?>(Widget widget) {
  Route<T> route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
//      isInitialRoute: false,
    ),
  );
  return navGK.currentState?.pushReplacement(route);
}

popToPage(Widget page) {
  navGK.currentState?.popUntil(ModalRoute.withName('$page'));
}

pushReplacement(Widget page) {
  navGK.currentState?.pushReplacement(new MaterialPageRoute<dynamic>(
    builder: (BuildContext context) {
      return page;
    },
  ));
}

popToRootPage() {
  navGK.currentState?.popUntil(ModalRoute.withName('/'));
}

fastCall([url = '18176681925']) async {
  await launch("tel:$url");
}

fastOpenUrl([url]) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("bad url");
  }
}
