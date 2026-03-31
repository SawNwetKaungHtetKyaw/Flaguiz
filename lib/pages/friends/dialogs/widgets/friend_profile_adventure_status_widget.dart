import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class FriendProfileAdventureStatusWidget extends StatelessWidget {
  const FriendProfileAdventureStatusWidget({super.key, required this.list});

  final List<AdventureCompletedModel> list;
  @override
  Widget build(BuildContext context) {
    const double statusFontSize = 9;
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
                    image: AssetImage(AssetsImages.adventureIcon))),
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
                      text: "- $flagCount/23", fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- $countryCount/23", fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- $mapCount/23", fontSize: statusFontSize),
                  const SizedBox(height: 8),
                  CcShadowedTextWidget(
                      text: "- $capitalCount/23", fontSize: statusFontSize),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
