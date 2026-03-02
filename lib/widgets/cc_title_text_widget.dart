import 'package:flutter/material.dart';

class CcTitleTextWidget extends StatelessWidget {
  const CcTitleTextWidget(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.fontSize = 18,
      this.fontWeight = FontWeight.w700,
      this.textAlign,
      this.overflow});
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style:
          TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
