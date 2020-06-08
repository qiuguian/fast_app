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

part 'param_util.dart';

final navGK = new GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> scaffoldGK;

Future<dynamic> fastRoutePush(Widget widget) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
//      isInitialRoute: false,
    ),
  );
  return navGK.currentState.push(route);
}

Future<dynamic> routeReplace(Widget widget) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
//      isInitialRoute: false,
    ),
  );
  return navGK.currentState.pushReplacement(route);
}

popToPage(Widget page) {
  navGK.currentState.pushAndRemoveUntil(new MaterialPageRoute<dynamic>(
    builder: (BuildContext context) {
      return page;
    },
  ), (Route<dynamic> route) => false);
}

pushReplacement(Widget page) {
  navGK.currentState.pushReplacement(new MaterialPageRoute<dynamic>(
    builder: (BuildContext context) {
      return page;
    },
  ));
}

popToRootPage() {
  navGK.currentState.popUntil(ModalRoute.withName('/'));
}

fastCall([url = '18176681925']) async {
  await launch("tel:$url");
}

fastOpenUrl([url]) async {
  if (await canLaunch(url)) {
    await launch(url);
  }else{
    print("bad url");
  }
}
