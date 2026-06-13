import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class PlayerProfileWidget extends StatelessWidget {
  const PlayerProfileWidget({
    super.key,
    required this.user,
    required this.result,
  });

  final MiniProfileModel user;
  final String result;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SlideAnimation(
      child: ClipPath(
        clipper: SlantedClipper(),
        child: Container(
          width: width / 2 + 20,
          height: 80,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color:
                (result == CcConstants.BATTLE_WIN)
                    ? battleWinColor
                    : (result == CcConstants.BATTLE_LOSE)
                    ? battleLoseColor
                    : primaryColor,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CcProfileImageWidget(
                    size: 60,
                    avatar: user.avatar ?? 'AVT_001',
                    border: user.border ?? 'BD_001',
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
                          (user.country == null)
                              ? AssetsImages.defaultCountry
                              : (user.country?.localFlagPath == null)
                              ? "${CcConfig.image_base_url}${user.country?.flagUrl}"
                              : user.country?.localFlagPath ?? '',
                    ),
                  ),
                ],
              ),
              CcShadowedTextWidget(
                padding: const EdgeInsets.only(left: 3),
                overflow: TextOverflow.clip,
                maxLines: 1,
                fontSize: 10,
                dx: 1,
                dy: 1.5,
                text: user.username ?? "Player",
                letterSpacing: 1,
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

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 40, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
