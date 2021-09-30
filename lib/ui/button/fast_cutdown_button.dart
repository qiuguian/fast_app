import 'dart:async';

import 'package:flutter/material.dart';

_FastCutDownButtonState? _state;

String cutDownDurationKey = "CutDownDurationKey";

class FastCutDownButton extends StatefulWidget {
  FastCutDownButton({
    this.height,
    this.time,
    this.backgroundColor = Colors.blue,
    this.border,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.onTap,
    this.text = "获取验证码",
    this.textStyle = const TextStyle(color: Colors.white),
  });

  final double? height;
  final int? time;
  final Color backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String text;
  final TextStyle textStyle;

  ///num 倒计时多少秒
  static sendSuccess([int cutDownTime = 60]) =>
      _state?.sendSuccess(cutDownTime);

  @override
  _FastCutDownButtonState createState() {
    _state = _FastCutDownButtonState();
    return _state!;
  }
}

int _cutDownNum = 0;

class _FastCutDownButtonState extends State<FastCutDownButton> {
  String text = "";
  Timer? _timer;

  @override
  void initState() {
    text = widget.text;
    super.initState();
    setState(() {});

    /// 如果没倒计时完，重新进来时继续倒计时
    if(_cutDownNum > 0){
      createTimer(_cutDownNum);
    }
  }

  //发送请求成功后 开始倒计时
  void sendSuccess([int? cutDownTime]) {
    createTimer(cutDownTime);
  }

  void createTimer([int? cutDownTime]) async {
    _cutDownNum = 60;

    if (cutDownTime != null && cutDownTime > 0) {
      _cutDownNum = cutDownTime;
    }

    if(_timer?.isActive??false){
      stopTimer();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_cutDownNum > 0) {
        if (mounted) {
          _cutDownNum--;
          // AppCache.save(cutDownDurationKey, num.toString());
          text = "重新发送($_cutDownNum)";
          setState(() {});
        }
      } else {
        text = "重新发送";
        setState(() {});
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _cutDownNum == 0 ? widget.backgroundColor : Colors.grey.withAlpha(50),
          borderRadius: widget.borderRadius,
          border: _cutDownNum == 0
              ? widget.border
              : Border.all(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        child: Text(text, style: widget.textStyle),
      ),
      onTap: () {
        if (_cutDownNum == 0) {
          widget.onTap?.call();
        }
      },
    );
  }
}
