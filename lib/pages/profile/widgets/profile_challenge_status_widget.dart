import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ProfileChallengeStatusWidget extends StatelessWidget {
  const ProfileChallengeStatusWidget({super.key, required this.list});

  final List<ChallengeCompletedModel> list;

  @override
  Widget build(BuildContext context) {
    const double statusFontSize = 8;
    ChallengeCompletedModel flag =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__FLAG);
    ChallengeCompletedModel country =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__COUNTRY);
    ChallengeCompletedModel map =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__MAP);
    ChallengeCompletedModel capital =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__CAPITAL);
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsImages.challengeIcon))),
          ),
          const CcShadowedTextWidget(
            text: CcConstants.kChallengeStatus,
            textAlign: TextAlign.center,
            fontSize: 10,
          ),
          Container(
            width: double.maxFinite,
            height: 180,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.profileBox),
                  fit: BoxFit.fill),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CcShadowedTextWidget(
                        text: CcConstants.kFLAG, fontSize: statusFontSize),
                    CcShadowedTextWidget(
                        text: CcConstants.kCOUNTRY, fontSize: statusFontSize),
                    CcShadowedTextWidget(
                        text: CcConstants.kMAP, fontSize: statusFontSize),
                    CcShadowedTextWidget(
                        text: CcConstants.kCAPITAL, fontSize: statusFontSize),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CcShadowedTextWidget(
                          text: "${flag.complete}/233",
                          fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "${country.complete}/233",
                          fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "${map.complete}/233",
                          fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "${capital.complete}/233",
                          fontSize: statusFontSize),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
