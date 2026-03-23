import 'package:flaguiz/service/audio_service.dart';
import 'package:flutter/material.dart';

class SocialIconWidget extends StatelessWidget {
  const SocialIconWidget(
      {super.key,
      required this.iconData,
      this.size = 80,
      this.color = Colors.white,
      required this.onTap});
  final IconData iconData;
  final double size;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          AudioService.instance.playSound('tap');
          onTap();
        },
        icon: Icon(
          iconData,
          color: color,
          size: size,
          shadows: const [BoxShadow(offset: Offset(2, 2))],
        ));
  }
}
