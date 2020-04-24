import 'package:flutter/material.dart';

class FastSeparator extends StatelessWidget {
  final double height;
  final Color color;
  final double margin;
  final Axis direction;

  const FastSeparator({this.height = 1, this.color = Colors
      .black, this.margin = 0, this.direction = Axis.horizontal,});

  @override
  Widget build(BuildContext context) {
    return direction == Axis.horizontal ? LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (3 * dashWidth)).floor();
        return new Padding(
            padding: EdgeInsets.symmetric(vertical: margin), child: Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        ));
      },
    ) : LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight() - 2 * margin;
        final dashWidth = height;
        final dashHeight = 2.0;
        final dashCount = (boxHeight / (3 * dashHeight)).floor();
        return new Padding(
            padding: EdgeInsets.symmetric(vertical: margin), child: Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
        ));
      },
    );
  }
}