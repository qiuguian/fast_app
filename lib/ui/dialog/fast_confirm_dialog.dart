import 'package:fast_app/fast_app.dart';
import 'package:flutter/material.dart';

Future<void> fastConfirmDialog(BuildContext context, {
  String title = "Confirm",
  String info = "",
  String cancelBtn = "Cancel",
  String sureBtn = "Sure",
  Callback onTap,
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(12),
                gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffe0e0e3), Color(0xffeeeaef)]),
              ),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 18, left: 30, right: 30),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          '$title',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Color(0xff030303), fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: new Text(
                      '$info',
                      style:
                      new TextStyle(color: Color(0xff030303), fontSize: 13),
                    ),
                  ),
                  new Container(
                    height: 0.5,
                    margin: EdgeInsets.only(top: 10),
                    color: Color(0xff4d4d4d).withAlpha(100),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new FastButton(
                        text: '$cancelBtn',
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4 - 1,
                        style: new TextStyle(color: Colors.grey),
                        onTap: () {
                          Navigator.pop(context);
                          if (onTap != null) {
                            onTap(false);
                          }
                        },
                      ),
                      new Container(
                        width: 0.5,
                        height: 45,
                        color: Color(0xff4d4d4d).withAlpha(100),
                      ),
                      new FastButton(
                        text: '$sureBtn',
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4 - 1,
                        style: new TextStyle(color: Colors.blue),
                        onTap: () {
                          if (onTap != null) {
                            Navigator.pop(context);
                            onTap(true);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
