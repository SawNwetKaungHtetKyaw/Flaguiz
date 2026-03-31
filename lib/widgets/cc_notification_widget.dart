import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcNotificationWidget extends StatelessWidget {
  const CcNotificationWidget(
      {super.key,
      required this.isVisiable,
      required this.count,
      this.width = 18,
      this.height = 18,
      this.color = errorColor,
      this.margin});

  final bool isVisiable;
  final double width, height;
  final Color color;
  final String count;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisiable,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: margin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: const [
            BoxShadow(
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: CcShadowedTextWidget(text: count, fontSize: 8, dx: 1, dy: 1),
      ),
    );
  }
}
