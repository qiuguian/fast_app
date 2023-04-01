import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastRowView extends StatelessWidget {
  final String title;
  final bool hiddenRightArrow;
  final bool hiddenDivider;
  final Widget? trail;
  final Widget? left;
  final Widget? prefix;
  final BuildContext? context;
  final VoidCallback? onTap;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextStyle? style;

  FastRowView({
    required this.title,
    this.hiddenRightArrow = false,
    this.trail,
    this.left,
    this.prefix,
    this.context,
    this.onTap,
    this.height = 60.0,
    this.margin = EdgeInsets.zero,
    this.hiddenDivider = false,
    this.padding = const EdgeInsets.only(left: 15, right: 10.0),
    this.style,
  });

  actions(v) => onTap?.call();

  @override
  Widget build(BuildContext context) {
    bool isNeed = title.contains("*");
    String _title = title.replaceAll("*", "");
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => actions(_title),
      child: Container(
        height: height == 0 ? null : height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          border: hiddenDivider ? null : new Border(
            bottom: BorderSide(
              color: Color(0xfff9f9f9), width: 1.0,),),),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            prefix ?? Container(),
            new Text(
              '$_title',
              style: style,
            ),
            Visibility(
              visible: isNeed,
              child: new Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Expanded(child: Container(
              margin: EdgeInsets.only(left: 20),
              child: left ?? Container(),
            )),
            new Wrap(
              spacing: 5.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                trail ?? new Container(),
                new Visibility(
                    visible: !hiddenRightArrow,
                    child: new Icon(
                      CupertinoIcons.right_chevron, color: Colors.grey,
                      size: 16,)
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
  final Widget? trail;
  final BuildContext? context;
  final VoidCallback? onTap;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final double height;

  FastCustomRowView({
    required this.title,
    this.hiddenRightArrow = false,
    this.trail,
    this.context,
    this.onTap,
    this.icon,
    this.padding = const EdgeInsets.only(left: 20.0),
    this.height = 50,
  });

  actions(v) => onTap?.call();

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => actions(title),
      child: new Container(
        padding: padding,
        color: Colors.white,
        child: Container(
          height: height,
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