import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_app/fast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class FastBannerView extends StatelessWidget implements PreferredSizeWidget {
  FastBannerView({
    required this.height,
    required this.banners,
    this.onTap,
    this.scale = 1.0,
    this.viewportFraction = 1.0,
    this.radius = 0.0,
    this.alignment = Alignment.bottomCenter,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.pagination = true,
    this.onIndexChanged,
  });

  final double height;
  final List banners;
  final Callback? onTap;
  final double scale;
  final double viewportFraction;
  final double radius;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool pagination;
  final ValueChanged<int>? onIndexChanged;

  @override
  Size get preferredSize =>
      new Size(MediaQueryData
          .fromWindow(window)
          .size
          .width, height);

  clickBanner([index = 0]) {
    onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    List indexS = [];

    for (int i = 0; i < banners.length; i++) {
      indexS.add(i);
    }

    if (banners.isEmpty) {
      return Container(height: height);
    }

    return new Container(
      height: height,
      padding: padding,
      color: backgroundColor,
      child: new Swiper(
        itemCount: banners.length,
        onIndexChanged: onIndexChanged,
        itemBuilder: (BuildContext context, int index) {
          String imgSrc = banners[index];
          return new InkWell(
            onTap: () => clickBanner(index),
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(radius),
              child: imgSrc.contains('http') ? new CachedNetworkImage(
                imageUrl: '$imgSrc',
                fit: BoxFit.cover,
                height: height,
              ) : imgSrc != ''
                  ? new Image.asset('$imgSrc', fit: BoxFit.cover,)
                  : Container(),
            ),
          );
        },
        physics: banners.length > 1
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        autoplay: banners.length > 1,
        pagination: (banners.length > 1 && pagination) ? SwiperPagination(
          alignment: alignment,
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
        ) : null,
        scale: scale,
        viewportFraction: viewportFraction,
      ),
    );
  }
}
