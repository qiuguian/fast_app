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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          InkWell(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                String img = widget.pics[index];
                return img.startsWith('http')
                    ? PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage("$img"),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                      )
                    : PhotoViewGalleryPageOptions(
                        imageProvider: FileImage(File(img)),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                      );
              },
              itemCount: widget.pics.length,
              pageController: PageController(initialPage: widget.index),
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          Positioned(
            bottom: 20.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 25.0,
              alignment: Alignment.center,
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(widget.pics.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
          Positioned(
            top: 25,
            left: 20.0,
            child: InkWell(
              child: Container(
                child: Icon(
                  CupertinoIcons.left_chevron,
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withAlpha(50)),
              ),
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
