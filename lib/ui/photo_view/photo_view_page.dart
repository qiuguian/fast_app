import 'package:fast_app/data/fast_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io';

class PhotoViewPage extends StatefulWidget {
  final List pics;
  final bool isImg;
  final int index;

  PhotoViewPage(this.pics, this.index, {this.isImg = false});

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() => currentIndex = widget.index);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        children: <Widget>[
          new InkWell(
            child: new PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                String img = widget.pics[index];
                return new PhotoViewGalleryPageOptions(
                  imageProvider: img.startsWith('http')
                      ? NetworkImage("$img")
                      : FileImage(File(img)),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  // maxScale: 3.0,
                  // minScale: 0.3,
                );
              },
              itemCount: widget.pics.length,
              pageController: new PageController(initialPage: widget.index),
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          new Positioned(
            bottom: 20.0,
            child: new Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 25.0,
              alignment: Alignment.center,
              child: new Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(widget.pics.length, (index) {
                  return new Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0)),
                      color: index == currentIndex
                          ? Colors.blue
                          : Color(0xffDCDCDC),
                    ),
                    height: 8.0,
                    width: 8.0,
                  );
                }),
              ),
            ),
          ),
          new Positioned(
            top: 25,
            left: 20.0,
            child: InkWell(
              child: Container(
                child: Icon(CupertinoIcons.left_chevron, color: Colors.white,),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withAlpha(50)
                ),
              ),
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
