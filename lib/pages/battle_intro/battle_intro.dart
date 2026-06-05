import 'dart:async';

import 'package:flaguiz/animations/scale_animation.dart';
import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/pages/battle_intro/widgets/battle_intro_banner_widget.dart';
import 'package:flaguiz/pages/battle_intro/widgets/battle_intro_profile_widget.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class BattleIntro extends StatefulWidget {
  const BattleIntro(
      {super.key,
      required this.questions,
      required this.user,
      required this.bot,
      required this.botDifficulty});
  final List<BattleQuestionModel> questions;
  final MiniProfileModel user;
  final MiniProfileModel bot;
  final BotDifficulty botDifficulty;
  @override
  State<BattleIntro> createState() => _BattleIntroState();
}

class _BattleIntroState extends State<BattleIntro> {
  @override
  void initState() {
    super.initState();
    AudioService.instance.allowMusic = false;
    AudioService.instance.pause();
    Utils.preLoadRewardedAds(CcAdsKey.rewardDouble);
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RoutePaths.battleGame,
          arguments: [
            widget.questions,
            widget.user,
            widget.bot,
            Utils.botDifficultyByTrophy(widget.user.trophy ?? 0)
          ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage(AssetsImages.battleBg),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.6),
                  BlendMode.darken,
                ))),
        child: Stack(
          children: [
            /// User Banner
            BattleIntroBannerWidget(
              player: widget.user,
              isYou: true
            ),

            /// Bot Banner
            BattleIntroBannerWidget(
                player: widget.bot,
                isYou: false),

            /// Vs
            const ScaleAnimation(
              milisecond: 700,
              child: Align(
                  alignment: Alignment.center,
                  child: CcShadowedTextWidget(
                      padding: EdgeInsets.only(top: 30),
                      text: "VS",
                      fontSize: 50)),
            ),

            /// User Profile
            Align(
                alignment: Alignment.topCenter,
                child:
                    BattleIntroProfileWidget(isYou: true, player: widget.user)),

            /// Bot Profile
            Align(
                alignment: Alignment.bottomRight,
                child:
                    BattleIntroProfileWidget(isYou: false, player: widget.bot))
          ],
        ),
      ),
    );
  }
}
