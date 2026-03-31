import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class FriendProfileChallengeStatusWidget extends StatelessWidget {
  const FriendProfileChallengeStatusWidget({super.key, required this.list});

  final List<ChallengeCompletedModel> list;
  @override
  Widget build(BuildContext context) {
    const double statusFontSize = 9;
    ChallengeCompletedModel flag =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__FLAG);
    ChallengeCompletedModel country =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__COUNTRY);
    ChallengeCompletedModel map =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__MAP);
    ChallengeCompletedModel capital =
        list.firstWhere((c) => c.mode == CcConfig.GAME_MODE__CAPITAL);
    return Container(
      width: double.maxFinite,
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.5),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsImages.challengeIcon))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CcShadowedTextWidget(
                      letterSpacing: 1,
                      text: CcConstants.kFLAG,
                      fontSize: statusFontSize),
                  SizedBox(height: 8),
                  CcShadowedTextWidget(
                      letterSpacing: 1,
                      text: CcConstants.kCOUNTRY,
                      fontSize: statusFontSize),
                  SizedBox(height: 8),
                  CcShadowedTextWidget(
                      letterSpacing: 1,
                      text: CcConstants.kMAP,
                      fontSize: statusFontSize),
                  SizedBox(height: 8),
                  CcShadowedTextWidget(
                      letterSpacing: 1,
                      text: CcConstants.kCAPITAL,
                      fontSize: statusFontSize),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CcShadowedTextWidget(
                      text: "- ${flag.complete}/23", fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- ${country.complete}/23",
                      fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- ${map.complete}/23", fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- ${capital.complete}/23",
                      fontSize: statusFontSize),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
