///
/// fast_theme.dart
/// fast_app
/// Created by qiuguian on 2019/10/21.
/// Copyright © 2019 fastapp. All rights reserved.
///
/// website: http://www.fastapp.top
///

import 'package:flutter/material.dart';

FastTheme fastTheme = new FastTheme();

class FastTheme {

  Color lineColor;

  Color fontColor;

  Color appBarColor;
  Color appBarTextColor;
  Color backgroundColor;
  Color mainColor;
  Brightness brightness;

  FastTheme({
    this.appBarColor = const Color(0xFFFFFFFF),
    this.appBarTextColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFF7F6FB),
    this.mainColor = const Color(0xFFCC1D2A),
    this.lineColor = const Color(0xffF7F7F7),
    this.brightness = Brightness.dark,
    this.fontColor = const Color(0xFF3C3C3C),
  });
}

