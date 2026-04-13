import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class PlayerProfileWidget extends StatelessWidget {
  const PlayerProfileWidget(
      {super.key, required this.user, required this.result});

  final BotModel user;
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
            color: (result == CcConstants.BATTLE_WIN)
                ? battleWinColor
                : (result == CcConstants.BATTLE_LOSE)
                    ? battleLoseColor
                    : primaryColor,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CcNetworkImageWidget(
                      width: 60,
                      height: 60,
                      imageUrl:
                          "${CcConfig.image_base_url}${user.avatar}"),
                  CcNetworkImageWidget(
                      width: 60,
                      height: 60,
                      imageUrl:
                          "${CcConfig.image_base_url}${user.border}"),
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
                  letterSpacing: 1)
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
