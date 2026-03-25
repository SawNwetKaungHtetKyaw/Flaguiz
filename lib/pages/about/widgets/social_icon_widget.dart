import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';

class SocialIconWidget extends StatelessWidget {
  const SocialIconWidget(
      {super.key,
      required this.icon,
      this.size = 60,
      this.color = Colors.white,
      required this.onTap});
  final String icon;
  final double size;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AudioService.instance.playSound('tap');
        onTap();
      },
      child: CcShadowedImageBoxWidget(
        width: size,
        height: size,
        image: icon,
        radius: 0,
        dx: 0,
        dy: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
