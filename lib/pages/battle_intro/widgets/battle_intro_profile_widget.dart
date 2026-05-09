import 'package:flaguiz/animations/scale_animation.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class BattleIntroProfileWidget extends StatefulWidget {
  const BattleIntroProfileWidget(
      {super.key, required this.isYou, required this.player});
  final bool isYou;
  final BotModel player;

  @override
  State<BattleIntroProfileWidget> createState() =>
      _BattleIntroProfileWidgetState();
}

class _BattleIntroProfileWidgetState extends State<BattleIntroProfileWidget> {
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
              CcNetworkImageWidget(
                  width: 100,
                  height: 100,
                  imageUrl:
                      "${CcConfig.image_base_url}${widget.player.avatar}"),
              CcNetworkImageWidget(
                  width: 100,
                  height: 100,
                  imageUrl:
                      "${CcConfig.image_base_url}${widget.player.border}"),
              Positioned(
                bottom: 0,
                right: 0,
                child: CcShadowedImageBoxWidget(
                    width: 25,
                    height: 25,
                    radius: 25,
                    boxFit: BoxFit.cover,
                    image:(widget.player.country == null)
                              ? AssetsImages.regionIcon
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
