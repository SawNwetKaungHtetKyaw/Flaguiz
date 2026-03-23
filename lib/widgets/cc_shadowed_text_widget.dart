import 'package:flutter/material.dart';

class CcShadowedTextWidget extends StatelessWidget {
  final String text;
  final Color strokeColor, textColor;
  final double strokeWidth, fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double dx, dy;
  final Color shadowColor;
  final double letterSpacing;
  final EdgeInsetsGeometry padding;
  final String? fontFamily;

  const CcShadowedTextWidget(
      {super.key,
      required this.text,
      this.fontFamily,
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
      this.letterSpacing = 2,
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: TextStyle(
          fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            shadows: [BoxShadow(color: shadowColor, offset: Offset(dx, dy))]),
      ),
    );
  }
}
