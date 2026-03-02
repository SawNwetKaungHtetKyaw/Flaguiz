import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ProfileAdventureStatusWidget extends StatelessWidget {
  const ProfileAdventureStatusWidget({super.key, required this.list});

  final List<AdventureCompletedModel> list;

  @override
  Widget build(BuildContext context) {
    const double statusFontSize = 8;
    final String flagCount = list
        .where((adv) =>
            adv.levelId!.startsWith("${CcConfig.GAME_MODE__FLAG}_") &&
            adv.life != '0')
        .length
        .toString();
    final String countryCount = list
        .where((adv) =>
            adv.levelId!.startsWith("${CcConfig.GAME_MODE__COUNTRY}_") &&
            adv.life != '0')
        .length
        .toString();
    final String mapCount = list
        .where((adv) =>
            adv.levelId!.startsWith("${CcConfig.GAME_MODE__MAP}_") &&
            adv.life != '0')
        .length
        .toString();
    final String capitalCount = list
        .where((adv) =>
            adv.levelId!.startsWith("${CcConfig.GAME_MODE__CAPITAL}_") &&
            adv.life != '0')
        .length
        .toString();
    return Flexible(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsImages.adventureIcon))),
          ),
          const CcShadowedTextWidget(
            text: CcConstants.kAdventureStatus,
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
                          text: "$flagCount/23", fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "$countryCount/23", fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "$mapCount/23", fontSize: statusFontSize),
                      CcShadowedTextWidget(
                          text: "$capitalCount/23", fontSize: statusFontSize),
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
