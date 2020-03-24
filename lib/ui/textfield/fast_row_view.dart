import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastRowView extends StatelessWidget {
  final String title;
  final bool hiddenRightArrow;
  final Widget trail;
  final BuildContext context;
  final VoidCallback onTap;

  FastRowView({
    this.title,
    this.hiddenRightArrow = false,
    this.trail,
    this.context,
    this.onTap,
  });

  actions(v) {
    if (onTap != null) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => actions(title),
      child: new Container(
        padding: EdgeInsets.only(left: 15.0),
        color: Colors.white,
        child: Container(
          height: 60.0,
          padding: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom: new BorderSide(
                      color: Color(0xfff9f9f9), width: 1.0))),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                '$title',
              ),
              new Wrap(
                spacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  trail ?? new Container(),
                  new Visibility(
                      visible: !hiddenRightArrow,
                      child: new Icon(CupertinoIcons.right_chevron, color: Colors.grey)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}