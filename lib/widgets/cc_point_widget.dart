import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flutter/material.dart';

class CcPointWidget extends StatelessWidget {
  const CcPointWidget({super.key, required this.point, this.iconSize = 30});
  final String point;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final int p = int.parse(point);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CcShadowedIconWidget(
            size: iconSize, color: (p >= 1) ? Colors.red : Colors.white),
        CcShadowedIconWidget(
            size: iconSize, color: (p >= 2) ? Colors.red : Colors.white),
        CcShadowedIconWidget(
            size: iconSize, color: (p >= 3) ? Colors.red : Colors.white),
      ],
    );
  }
}
