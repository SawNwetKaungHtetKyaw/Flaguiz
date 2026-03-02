import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flutter/material.dart';

class ChallengeVictoryIconButtonWidget extends StatelessWidget {
  const ChallengeVictoryIconButtonWidget(
      {super.key, required this.icon, required this.onTap});
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CcImageButton(
          margin: const EdgeInsets.all(0),
          image: AssetsImages.challengeButtonHaf,
          height: 60,
          widget: CcShadowedIconWidget(
            color: Colors.white,
            icon: icon,
            size: 50,
            offset: const Offset(2, 2),
          ),
          onTap: () => onTap()),
    );
  }
}
