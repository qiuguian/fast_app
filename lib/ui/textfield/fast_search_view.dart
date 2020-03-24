import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FastSearchView extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final EdgeInsetsGeometry margin;
  final TextEditingController controller;

  FastSearchView({this.onTap, this.text, this.margin, this.controller});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Color(0xffF2F2F7),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 40.0,
        child: new TextField(
            controller: controller ?? TextEditingController(),
            decoration: InputDecoration(
              hintText: text ?? '',
              prefixIcon: new Icon(CupertinoIcons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (v) {
              onTap();
            }),
      ),
      onTap: onTap ?? () {},
    );
  }
}