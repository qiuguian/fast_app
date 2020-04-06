import 'package:flutter/material.dart';

typedef DidSelect(item);

void fastSelectImageView(BuildContext context, {DidSelect didSelect}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        List data = [
          '相机',
          '相册',
        ];

        return new Material(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(4),
                ),
                child: new Wrap(
                  children: data.map((item) {
                    return new InkWell(
                      onTap: () {
                        if (didSelect != null) {
                          didSelect(item);
                          Navigator.of(context).pop();
                        }
                      },
                      child: new Container(
                        height: 60.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: new BorderSide(
                                    color: Color(0xffEBEBEB), width: 0.5))),
                        child: new Text('$item',
                            style: new TextStyle(
                                color: Color(0xff333333), fontSize: 19)),
                      ),
                    );
                  }).toList(growable: false),
                ),
              ),
              new InkWell(
                child: new Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(4),
                  ),
                  child: new Text('取消'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      });
}

void fastSelectBottomView(BuildContext context,
    {
      String title = "Select",
      String cancelName = "Cancel",
      List menu,
      DidSelect didSelect,
      Color titleColor = Colors.grey,
      Color valueColor = Colors.blue,
      Color cancelColor = Colors.blue,
    }) {
  List data = menu ?? [
    '请输入选项',
  ];

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return new Material(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(4),
                ),
                child: new Wrap(
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: new BorderSide(
                              color: Color(0xffEBEBEB), width: 0.5),),),
                      child: new Text('$title',
                          style: new TextStyle(
                              color: titleColor, fontSize: 15)),
                    ),
                    new Wrap(
                      children: data.map((item) {
                        return new InkWell(
                          onTap: () {
                            if (didSelect != null) {
                              didSelect(item);
                              Navigator.of(context).pop();
                            }
                          },
                          child: new Container(
                            height: 55.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: new BorderSide(
                                        color: Color(0xffEBEBEB), width: 0.5))),
                            child: new Text('$item',
                                style: new TextStyle(
                                    color: valueColor, fontSize: 19)),
                          ),
                        );
                      }).toList(growable: false),
                    ),
                  ],
                ),
              ),
              new InkWell(
                child: new Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(4),
                  ),
                  child: new Text('$cancelName',
                      style: new TextStyle(color: cancelColor, fontSize: 19)),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      });
}

