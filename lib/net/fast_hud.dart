import 'dart:async';

import 'package:flutter/material.dart';

_FastHudState _state;

class FastHud extends StatefulWidget {
  FastHud();

  static show({hud = '加载中…'}) => _state.show(hud: hud);

  static hidden() => _state.hidden();

  @override
  State<StatefulWidget> createState() {
    _state = _FastHudState();

    return _state;
  }
}

class _FastHudState extends State<FastHud> {
  var offstage = true;

  String _hud = '';

  show({hud}) {
    offstage = false;
    _hud = hud;
    _doRefresh();
  }

  hidden() {
    offstage = true;

    _doRefresh();
  }

  _doRefresh() {
    Timer.run(() {
      if (mounted) setState(() {});
    });
  }

  Widget progress;

  @override
  void initState() {
    super.initState();

    Widget child = Text('$_hud', style: TextStyle(fontSize: 16.0));

    child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
//        Spacing.w12 * 2,
        child,
      ],
    );

    child = ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200.0, height: 64.0),
      child: child,
    );

    child = Card(child: child);

    progress = AbsorbPointer(child: Center(child: child));
  }

  @override
  Widget build(BuildContext context) => offstage ? const Center() : progress;
}
