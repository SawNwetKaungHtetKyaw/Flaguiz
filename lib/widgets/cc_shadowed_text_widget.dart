import 'package:flutter/material.dart';

class CcShadowedTextWidget extends StatelessWidget {
  final String text;
  final Color strokeColor,textColor;
  final double strokeWidth,fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double dx,dy;
  final Color shadowColor;
  final double letterSpacing;

  const CcShadowedTextWidget({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.strokeColor = Colors.black,
    this.strokeWidth = 5,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.dx = 2,
    this.dy = 3,
    this.shadowColor = Colors.black,
    this.letterSpacing = 2
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        letterSpacing: letterSpacing,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows:[
          BoxShadow(
            color: shadowColor,
            offset: Offset(dx, dy)
          )
        ]
      ),
    );
  }
}