import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_point_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureLevelWidget extends StatelessWidget {
  const AdventureLevelWidget(
      {super.key,
      required this.mode,
      required this.adventureModel,
      required this.paddingTop});
  final String mode;
  final AdventureModel adventureModel;
  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    AdventureCompletedModel? adventureCompleted;
    return Consumer2<CountryProvider, UserProvider>(
        builder: (context, countryProvider, userProvider, child) {
      List<CountryModel> countries = countryProvider.countryList;
      UserModel? user = userProvider.user;
      List<AdventureCompletedModel> adventureCompletedList =
          user?.adventureCompletedList ?? [];
      final String levelId =
          "${mode}_${(adventureModel.level ?? "0").padLeft(2, '0')}";

      for (AdventureCompletedModel item in adventureCompletedList) {
        if (item.levelId == levelId) {
          adventureCompleted = item;
          break;
        }
      }

      return Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: Stack(
          children: [
            /// Level button
            CcImageButton(
              margin: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
              padding: const EdgeInsets.only(right: 30, left: 30, bottom: 3),
              image: AssetsImages.adventureButton,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CcShadowedTextWidget(text: "Level ${adventureModel.level}"),
                  CcPointWidget(point: adventureCompleted?.life ?? "0"),
                ],
              ),
              onTap: () {
                AudioService.instance.playSound('tap');

                Utils.preLoadRewardedAds(CcAdsKey.rewardDouble);
                Utils.preLoadRewardedAds(CcAdsKey.rewardContinueGame);
                
                if (mode == CcConfig.GAME_MODE__FLAG ||
                    mode == CcConfig.GAME_MODE__MAP) {
                  Navigator.pushNamed(context, RoutePaths.adventureGameByImage,
                      arguments: [
                        Utils.prepareAdventureGameModeData(
                            adventureModel, countries),
                        mode,
                        levelId
                      ]);
                } else {
                  Navigator.pushNamed(context, RoutePaths.adventureGameByText,
                      arguments: [
                        Utils.prepareAdventureGameModeData(
                            adventureModel, countries),
                        mode,
                        levelId
                      ]);
                }
              },
            ),

            /// Locked
            Visibility(
              visible: adventureCompleted?.levelId != levelId,
              child: Container(
                width: double.maxFinite,
                height: 70,
                margin: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
