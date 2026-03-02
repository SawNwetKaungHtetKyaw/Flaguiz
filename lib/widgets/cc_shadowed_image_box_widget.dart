import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class CcShadowedImageBoxWidget extends StatelessWidget {
  const CcShadowedImageBoxWidget(
      {super.key,
      required this.width,
      required this.height,
      this.radius = 10,
      required this.image,
      this.shadowColor = Colors.black,
      this.dx = 2,
      this.dy = 3,
      this.padding,
      this.margin,
      this.boxFit = BoxFit.fill});
  final double width, height, radius , dx, dy;
  final String image;
  final Color shadowColor;
  final BoxFit boxFit;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(image: Utils.checkImageType(image),fit: boxFit),
          boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(dx, dy)
          )
        ]
          ),
    );
  }
}
