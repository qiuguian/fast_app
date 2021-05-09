import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_app/fast_app.dart';

class FastSearchView extends StatelessWidget {
  final GestureTapCallback? onTap;
  final GestureTapCallback? onSubmitted;
  final String? text;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final double radius;
  final Callback? onChange;
  final Color backgroundColor;

  FastSearchView({this.onTap,
    this.text,
    this.margin,
    this.controller,
    this.radius = 10.0,
    this.onChange,
    this.onSubmitted,
    this.backgroundColor = const Color(0xffF2F2F7),
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        height: 40.0,
        child: new TextField(
          controller: controller ?? TextEditingController(),
          enabled: onTap == null,
          decoration: InputDecoration(
            hintText: text ?? '',
            prefixIcon: new Icon(CupertinoIcons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10, bottom: 10),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (v) {
            onSubmitted?.call();
          },
          onChanged: (v) => onChange?.call(v),
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}