import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class BotProfileWidget extends StatelessWidget {
  const BotProfileWidget({super.key, required this.bot, required this.result});

  final MiniProfileModel bot;
  final String result;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SlideAnimation(
      begin: const Offset(1, 0),
      child: ClipPath(
        clipper: SlantedClipper(),
        child: Container(
          width: width / 2 + 20,
          height: 80,
          padding: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color:
                (result == CcConstants.BATTLE_WIN)
                    ? battleLoseColor
                    : (result == CcConstants.BATTLE_LOSE)
                    ? battleWinColor
                    : primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CcShadowedTextWidget(
                padding: const EdgeInsets.only(right: 3),
                overflow: TextOverflow.clip,
                maxLines: 1,
                dx: 1,
                dy: 1.5,
                fontSize: 10,
                text: bot.username ?? "Player",
                letterSpacing: 1,
              ),
              Stack(
                children: [
                  CcNetworkImageWidget(
                    width: 60,
                    height: 60,
                    imageUrl: "${CcConfig.image_base_url}${bot.avatar}",
                  ),
                  CcNetworkImageWidget(
                    width: 60,
                    height: 60,
                    imageUrl: "${CcConfig.image_base_url}${bot.border}",
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CcShadowedImageBoxWidget(
                      width: 20,
                      height: 20,
                      radius: 20,
                      dx: 1,
                      dy: 1,
                      boxFit: BoxFit.cover,
                      image:
                          (bot.country == null)
                              ? AssetsImages.regionIcon
                              : (bot.country?.localFlagPath == null)
                              ? "${CcConfig.image_base_url}${bot.country?.flagUrl}"
                              : bot.country?.localFlagPath ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(40, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
