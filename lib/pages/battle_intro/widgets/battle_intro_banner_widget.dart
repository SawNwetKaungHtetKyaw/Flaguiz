import 'package:flaguiz/animations/fade_animation.dart';
import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/pages/profile/widgets/profile_banner_widget.dart';
import 'package:flutter/material.dart';

class BattleIntroBannerWidget extends StatelessWidget {
  const BattleIntroBannerWidget({
    super.key,
    required this.isYou,
    required this.player,
  });

  final MiniProfileModel player;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FadeAnimation(
      child: SlideAnimation(
        begin: Offset(isYou ? -1 : 1, isYou ? -0.3 : 0.3),
        milisecond: 700,
        child: Align(
          alignment: Alignment.center,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(isYou ? 1.0 : -1.0, 1.0, 1.0),
            child: ProfileBannerWidget(
              height: screenSize.width / 3,
              padding: EdgeInsets.only(
                right: 85,
                left: 5,
                bottom: isYou ? screenSize.width / 3 : 0,
                top: isYou ? 0 : screenSize.width / 3,
              ),
              id: player.banner ?? 'BN_001',
            ),

          ),
        ),
      ),
    );
  }
}
