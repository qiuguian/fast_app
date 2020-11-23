import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastRowView extends StatelessWidget {
  final String title;
  final bool hiddenRightArrow;
  final Widget trail;
  final Widget prefix;
  final BuildContext context;
  final VoidCallback onTap;
  final double height;

  FastRowView({
    this.title,
    this.hiddenRightArrow = false,
    this.trail,
    this.prefix,
    this.context,
    this.onTap,
    this.height = 60.0,
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
      child: Container(
        height: height ?? 50,
        padding: EdgeInsets.only(left: 15, right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border(
                bottom: new BorderSide(
                    color: Color(0xfff9f9f9), width: 1.0))),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            prefix ?? Container(),
            new Text(
              '$title',
            ),
            Expanded(child: Container()),
            new Wrap(
              spacing: 10.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                trail ?? new Container(),
                new Visibility(
                    visible: !hiddenRightArrow,
                    child: new Icon(
                        CupertinoIcons.right_chevron, color: Colors.grey)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FastCustomRowView extends StatelessWidget {
  final String title;
  final bool hiddenRightArrow;
  final Widget trail;
  final BuildContext context;
  final VoidCallback onTap;
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final double height;

  FastCustomRowView({
    this.title,
    this.hiddenRightArrow = false,
    this.trail,
    this.context,
    this.onTap,
    this.icon,
    this.padding = const EdgeInsets.only(left: 20.0),
    this.height = 50,
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
        padding: padding,
        color: Colors.white,
        child: Container(
          height: height ?? 50.0,
          padding: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom: new BorderSide(
                      color: Color(0xfff9f9f9), width: 1.0))),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Wrap(
                spacing: icon == null ? 0 : 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  icon ?? new Container(),
                  new Text(
                    '$title',
                    style: new TextStyle(color: Color(0xff888697),
                      fontSize: 14.0, fontWeight: FontWeight.w500,),
                  ),
                ],
              ),
              new Wrap(
                spacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  trail ?? new Container(),
                  new Visibility(
                      visible: !hiddenRightArrow,
                      child: new Icon(CupertinoIcons.right_chevron,
                          color: Colors.grey, size: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}