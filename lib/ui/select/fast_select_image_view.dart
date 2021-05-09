import 'package:flutter/material.dart';

typedef DidSelect(item);

void fastSelectImageView(BuildContext context,
    {DidSelect? didSelect, VoidCallback? didCancel,}) {
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

typedef DidSelectItem(item, index);

void fastSelectBottomView(BuildContext context,
    {
      String title = "Select",
      String cancelName = "Cancel",
      required List menu,
      DidSelectItem? didSelect,
      VoidCallback? didCancel,
      Color titleColor = Colors.grey,
      Color valueColor = Colors.blue,
      Color cancelColor = Colors.blue,
      Color currentColor = Colors.red,
      String? currentValue,
    }) {

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return new Material(
          color: Colors.transparent,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                      height: 50.0,
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
                        children: List.generate(menu.length, (index) {
                          return new InkWell(
                            onTap: () {
                              if (didSelect != null) {
                                Navigator.of(context).pop();
                                didSelect(menu[index], index);
                              }
                            },
                            child: new Container(
                              height: 55.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: new BorderSide(
                                          color: Color(0xffEBEBEB),
                                          width: 0.5))),
                              child: new Text('${menu[index]}',
                                  style: new TextStyle(
                                      color: currentValue == menu[index]
                                          ? currentColor
                                          : valueColor, fontSize: 19)),
                            ),
                          );
                        })
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
                  if (didCancel != null) {
                    didCancel();
                  }
                },
              )
            ],
          ),
        );
      });
}

