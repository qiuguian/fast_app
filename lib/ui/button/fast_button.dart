import 'package:flutter/material.dart';

class FastButton extends StatelessWidget {
  final double? width;
  final double height;
  final List<BoxShadow> boxShadow;
  final double radius;
  final String text;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle style;
  final Color? color;
  final bool isBorder;
  final int borderColor;
  final Gradient gradient;
  final bool enable;
  final bool isShow;

  FastButton({
    this.width,
    this.height = 45.0,
    this.boxShadow = const [],
    this.radius = 30.0,
    this.text = '按钮1',
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.margin,
    this.style = const TextStyle(color: Colors.black, fontSize: 16.0),
    this.color,
    this.isBorder = false,
    this.gradient = const LinearGradient(
      colors: [
        Color(0xff2F87FF),
        Color(0xff2F87FF),
      ],
    ),
    this.enable = true,
    this.borderColor = 0xffFC6973,
    this.isShow = true,
  });

  @override
  Widget build(BuildContext context) {
    return new Visibility(
      visible: isShow,
      child: new Container(
        margin: margin,
        child: new InkWell(
          child: new Container(
            alignment: Alignment.center,
            padding: padding,
            width: width,
            height: height,
            decoration: color == null
                ?
            BoxDecoration()
                : BoxDecoration(
              color: color!.withOpacity(enable ? 1 : 0.3),
              boxShadow: boxShadow,
              border: isBorder
                  ? Border.all(width: 0.5, color: Color(borderColor))
                  : null,
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
            child: new Text(
              '$text',
              style: style,
            ),
          ),
          onTap: () => onTap?.call()
        ),
      ),
    );
  }
}
