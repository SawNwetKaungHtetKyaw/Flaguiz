import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/animations/fade_animation.dart';
import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flutter/material.dart';

class BattleIntroBannerWidget extends StatelessWidget {
  const BattleIntroBannerWidget(
      {super.key,
      required this.isYou,
      required this.player,
      required this.heroTag});

  final BotModel player;
  final bool isYou;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Hero(
      tag: heroTag,
      child: FadeAnimation(
        child: SlideAnimation(
          begin: Offset(isYou ? -1 : 1, isYou ? -0.3 : 0.3),
          milisecond: 700,
          child: Align(
            alignment: Alignment.center,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(isYou ? 1.0 : -1.0, 1.0),
              child: Container(
                width: double.infinity,
                height: screenSize.width / 3,
                margin: EdgeInsets.only(
                    right: 85,
                    left: 5,
                    bottom: isYou ? screenSize.width / 3 : 0,
                    top: isYou ? 0 : screenSize.width / 3),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            cacheManager: CachedImageManagerService(),
                            "${CcConfig.image_base_url}${player.banner}"),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
