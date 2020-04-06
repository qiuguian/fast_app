import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_app/fast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FastBannerView extends StatelessWidget implements PreferredSizeWidget {
  FastBannerView({
    this.height,
    this.banners,
    this.onTap,
    this.scale = 1.0,
    this.viewportFraction = 1.0,
    this.radius = 0.0,
  });

  final double height;
  final List banners;
  final Callback onTap;
  final double scale;
  final double viewportFraction;
  final double radius;

  @override
  Size get preferredSize =>
      new Size(MediaQueryData
          .fromWindow(window)
          .size
          .width, height);

  clickBanner([index = 0]) {
    if (onTap != null) {
      onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    List indexS = new List();

    for (int i = 0; i < banners.length; i++) {
      indexS.add(i);
    }

    return new Container(
      height: height,
      child: new Swiper(
        itemCount: banners.length,
        itemBuilder: (BuildContext context, int index) {
          String imgSrc = banners[index];
          return new InkWell(
            onTap: () => clickBanner(index),
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(radius),
              child: imgSrc.contains('http') ? new CachedNetworkImage(
                imageUrl: '$imgSrc',
                fit: BoxFit.cover,
              ) : new Image.asset('$imgSrc', fit: BoxFit.cover,),
            ),
          );
        },
        autoplay: banners.length > 1,
        pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: new SwiperCustomPagination(
            builder: (context, config) {
              return new Wrap(
                spacing: 5,
                children: indexS.map((item) {
                  return new Container(
                    width: 15,
                    height: 2,
                    color: item == config.activeIndex
                        ? Color(0xffFE364E)
                        : Colors.white,
                  );
                }).toList(growable: false),
              );
            },
          ),
        ),
        scale: scale,
        viewportFraction: viewportFraction,
      ),
    );
  }
}
