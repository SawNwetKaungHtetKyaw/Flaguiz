import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/pages/adventure_game/provider/adventure_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureGameYouLoseWidget extends StatelessWidget {
  const AdventureGameYouLoseWidget({super.key, required this.guessList});
  final List<GuessModel> guessList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer2<AdventureGameProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      int userCoin = userProvider.user?.coin ?? 0;
      return Visibility(
        visible: provider.remainingLife < 1,
        child: Container(
          width: double.maxFinite,
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width / 12),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssetsImages.adventureYouLose))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CcShadowedTextWidget(
                      text: CcConstants.kYouLose, fontSize: 30, dx: 5, dy: 5),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Flexible(
                          child: CcImageButton(
                              margin: const EdgeInsets.only(
                                  bottom: 10, right: 3, left: 20),
                              image: AssetsImages.adventureButtonHalf,
                              widget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CcShadowedTextWidget(
                                      text: CcConstants.kPlayOn),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetsImages.coin, width: 20),
                                      CcShadowedTextWidget(
                                          text: "10 coins",
                                          letterSpacing: 1,
                                          textColor: (userCoin < 10)
                                              ? Colors.red
                                              : Colors.white),
                                    ],
                                  )
                                ],
                              ),
                              height: 60,
                              onTap: () {
                                if (userCoin >= 10) {
                                  AudioService.instance.playSound('claim');
                                  provider.playOn();
                                  userProvider.reduceUserCoin(10);
                                }
                              })),
                      Flexible(
                          child: CcImageButton(
                              margin: const EdgeInsets.only(
                                  bottom: 10, right: 20, left: 3),
                              image: AssetsImages.adventureButton,
                              text: CcConstants.kAds,
                              height: 60,
                              onTap: () {
                                if (AdsService.instance
                                    .isReady(CcAdsKey.rewardContinueGame)) {
                                  AdsService.instance.show(
                                      CcAdsKey.rewardContinueGame, context,
                                      () async {
                                    provider.playOn();
                                  });
                                } else {
                                  Utils.showToastMessage(
                                      context, "Unavailable Now");
                                }
                              }))
                    ],
                  ),

                  /// Re Play or Play Again
                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      image: AssetsImages.adventureButton,
                      text: CcConstants.kPlayAgain,
                      height: 60,
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        if (provider.mode == CcConfig.GAME_MODE__FLAG ||
                            provider.mode == CcConfig.GAME_MODE__MAP) {
                          Navigator.pushReplacementNamed(
                              context, RoutePaths.adventureGameByImage,
                              arguments: [
                                guessList,
                                provider.mode,
                                provider.levelId
                              ]);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, RoutePaths.adventureGameByText,
                              arguments: [
                                guessList,
                                provider.mode,
                                provider.levelId
                              ]);
                        }
                      }),
                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      image: AssetsImages.adventureButton,
                      text: CcConstants.kGiveUp,
                      height: 60,
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        Navigator.of(context).pop();
                        AudioService.instance.allowMusic = true;
                        AudioService.instance.resume();
                      })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
