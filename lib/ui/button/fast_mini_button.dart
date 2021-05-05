import 'package:flutter/material.dart';

class FastCustomButton extends StatelessWidget {
  final Gradient gradient;
  final Color color;
  final String text;
  final double fontSize;
  final double height;
  final double width;
  final Widget icon;
  final Color backgroundColor;
  final double radius;
  final Color borderColor;
  final VoidCallback onTap;
  final Axis direction;

  FastCustomButton({
    this.gradient = const LinearGradient(colors: [Colors.blue,Colors.blue]),
    this.color = Colors.white,
    this.text = 'button',
    this.fontSize = 15.0,
    this.height = 35,
    this.width,
    this.icon,
    this.backgroundColor,
    this.radius = 50.0,
    this.borderColor,
    this.onTap,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: (){
        if(onTap != null){
          onTap();
        }
      },
      child: Container(
        decoration: new BoxDecoration(
            gradient: backgroundColor != null ? null : gradient,
            color: backgroundColor,
            borderRadius: new BorderRadius.circular(radius),
            border: new Border.all(color: borderColor??(backgroundColor??Colors.transparent),width: 1)
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: height,
        width: width,
        alignment: Alignment.center,
        child: new Wrap(
          spacing: 10,
          direction: direction,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children:  icon != null ? <Widget>[
            icon,
            new Text('$text',style: new TextStyle(color: color,fontSize: fontSize)),
          ] : <Widget>[
            new Text('$text',style: new TextStyle(color: color,fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}
