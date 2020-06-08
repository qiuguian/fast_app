import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

fastToast(BuildContext context, String msg, {duration = 1}) {
  return Toast.show(
    msg ?? '请求失败',
    context,
    duration: duration,
    gravity: 3,
    backgroundRadius: 10.0,
    backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
  );
}

fastToastSuccess(BuildContext context, String msg, {Function timeOutCall}) {
  //创建一个OverlayEntry对象
  OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
    //外层使用Positioned进行定位，控制在Overlay中的位置
    return new Positioned(
        top: MediaQuery
            .of(context)
            .size
            .height * 0.5,
        child: new Material(
          color: Colors.transparent,
          child: new Container(
            color: Colors.transparent,
            width: MediaQuery
                .of(context)
                .size
                .width,
            alignment: Alignment.center,
            child: new Center(
              child: new Material(
                type: MaterialType.transparency,
                textStyle: new TextStyle(color: Colors.black),
                child: new Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(12.0)),
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 120,
                  child: new Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: new Image.asset(
                          'assets/ic_confirm.webp',
                          width: 58,
                          height: 52,
                          package: "fast_app",
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: new Text(msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          maxLines: 5,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  });
  //往Overlay中插入插入OverlayEntry
  Overlay.of(context).insert(overlayEntry);
  //两秒后，移除Toast
  new Future.delayed(Duration(seconds: 1)).then((value) {
    overlayEntry.remove();

    if (timeOutCall != null) {
      timeOutCall();
    }
  });
}
