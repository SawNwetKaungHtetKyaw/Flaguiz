import 'dart:async';

import 'package:flaguiz/animations/scale_animation.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/pages/battle_challenge_intro/widgets/battle_challenge_intro_banner_widget.dart';
import 'package:flaguiz/pages/battle_challenge_intro/widgets/battle_challenge_intro_profile_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/battle_question_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeIntro extends StatefulWidget {
  const BattleChallengeIntro({
    super.key,
    required this.roomId,
    required this.host,
    required this.friend,
    required this.questions,
    required this.isHost
  });
  final List<int> questions;
  final String roomId;
  final MiniProfileModel host;
  final MiniProfileModel friend;
  final bool isHost;
  @override
  State<BattleChallengeIntro> createState() => _BattleChallengeIntroState();
}

class _BattleChallengeIntroState extends State<BattleChallengeIntro> {
  @override
  void initState() {
    super.initState();
    AudioService.instance.allowMusic = false;
    AudioService.instance.pause();

    List<CountryModel> countries =
        Provider.of<CountryProvider>(context, listen: false).countryList;

    List<BattleQuestionModel> questions = BattleQuestionService()
        .generateBattleChallengeList(countries, widget.questions);

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.battleChallengeGame,
        arguments: [widget.roomId,questions, widget.host, widget.friend,widget.isHost],
      );
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
            ),
          ),
        ),
        child: Stack(
          children: [
            /// User Banner
            BattleChallengeIntroBannerWidget(player: widget.host, isYou: true),

            /// Bot Banner
            BattleChallengeIntroBannerWidget(
              player: widget.friend,
              isYou: false,
            ),

            /// Vs
            const ScaleAnimation(
              milisecond: 700,
              child: Align(
                alignment: Alignment.center,
                child: CcShadowedTextWidget(
                  padding: EdgeInsets.only(top: 30),
                  text: "VS",
                  fontSize: 50,
                ),
              ),
            ),

            /// User Profile
            Align(
              alignment: Alignment.topCenter,
              child: BattleChallengeIntroProfileWidget(
                isYou: true,
                player: widget.host,
              ),
            ),

            /// Bot Profile
            Align(
              alignment: Alignment.bottomRight,
              child: BattleChallengeIntroProfileWidget(
                isYou: false,
                player: widget.friend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
