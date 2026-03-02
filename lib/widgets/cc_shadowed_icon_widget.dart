
import 'package:flutter/material.dart';

class CcShadowedIconWidget extends StatelessWidget {
  const CcShadowedIconWidget({
    super.key,
    required this.color,
    this.icon = Icons.favorite,
    this.shadowColor = Colors.black,
    this.offset = const Offset(1, 1),
    this.size = 30
  });
  final Color color,shadowColor;
  final Offset offset;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
      shadows: [BoxShadow(color: Colors.black, offset: offset)],
    );
  }
}
