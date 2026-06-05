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

class FriendProfileWidget extends StatelessWidget {
  const FriendProfileWidget({
    super.key,
    required this.friend,
    required this.result,
  });

  final MiniProfileModel friend;
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
                text: friend.username ?? "Player",
                letterSpacing: 1,
              ),
              Stack(
                children: [
                  CcProfileImageWidget(
                    size: 60,
                    avatar: friend.avatar ?? 'AVT_001',
                    border: friend.border ?? 'BD_001',
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
                          (friend.country == null)
                              ? AssetsImages.defaultCountry
                              : (friend.country?.localFlagPath == null)
                              ? "${CcConfig.image_base_url}${friend.country?.flagUrl}"
                              : friend.country?.localFlagPath ?? '',
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
