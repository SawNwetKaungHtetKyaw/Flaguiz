import 'package:flaguiz/animations/scale_animation.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class BattleChallengeIntroProfileWidget extends StatefulWidget {
  const BattleChallengeIntroProfileWidget(
      {super.key, required this.isYou, required this.player});
  final bool isYou;
  final MiniProfileModel player;

  @override
  State<BattleChallengeIntroProfileWidget> createState() =>
      _BattleChallengeIntroProfileWidgetState();
}

class _BattleChallengeIntroProfileWidgetState extends State<BattleChallengeIntroProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      milisecond: 1000,
      child: Column(
        mainAxisAlignment:
            widget.isYou ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          Stack(
            children: [
              CcProfileImageWidget(avatar: widget.player.avatar ?? 'AVT_001', border: widget.player.border ?? 'BD_001'),
              Positioned(
                bottom: 0,
                right: 0,
                child: CcShadowedImageBoxWidget(
                    width: 25,
                    height: 25,
                    radius: 25,
                    boxFit: BoxFit.cover,
                    image:(widget.player.country == null)
                              ? AssetsImages.defaultCountry
                              :  (widget.player.country?.localFlagPath == null)
                        ? "${CcConfig.image_base_url}${widget.player.country?.flagUrl}"
                        : widget.player.country?.localFlagPath ?? ''),
              )
            ],
          ),
          Visibility(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              CcShadowedTextWidget(
                  padding: const EdgeInsets.only(left: 3),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  dx: 1,
                  dy: 1.5,
                  text: widget.player.username ?? "Player",
                  fontSize: 10,
                  letterSpacing: 1),
              const SizedBox(height: 3),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(AssetsImages.trophy, width: 20),
                CcShadowedTextWidget(
                    text: widget.player.trophy.toString(), fontSize: 10)
              ]),
            ],
          )),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
