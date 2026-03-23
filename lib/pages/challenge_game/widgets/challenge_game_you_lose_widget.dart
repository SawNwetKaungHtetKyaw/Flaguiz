import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameYouLoseWidget extends StatefulWidget {
  const ChallengeGameYouLoseWidget(
      {super.key,
      required this.guessList,
      required this.currentIndex,
      required this.mode});
  final List<GuessModel> guessList;
  final int currentIndex;
  final String mode;

  @override
  State<ChallengeGameYouLoseWidget> createState() =>
      _ChallengeGameYouLoseWidgetState();
}

class _ChallengeGameYouLoseWidgetState
    extends State<ChallengeGameYouLoseWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer2<ChallengeGameProvider, UserProvider>(
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
              margin: const EdgeInsets.only(bottom: 80),
              padding: EdgeInsets.symmetric(horizontal: size.width / 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssetsImages.challengeYouLose))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const CcShadowedTextWidget(
                      text: CcConstants.kYouLose, fontSize: 34, dx: 5, dy: 5),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Flexible(
                          child: CcImageButton(
                              margin: const EdgeInsets.only(
                                  bottom: 10, right: 20, left: 20),
                              height: 60,
                              image: AssetsImages.challengeButton,
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
                                          text: "10",
                                          textColor: (userCoin < 10)
                                              ? Colors.red
                                              : Colors.white),
                                    ],
                                  )
                                ],
                              ),
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
                                  bottom: 10, right: 20, left: 20),
                              height: 60,
                              image: AssetsImages.challengeButton,
                              text: CcConstants.kAds,
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
                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      height: 60,
                      image: AssetsImages.challengeButton,
                      text: CcConstants.kPlayAgain,
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        userProvider.updateUserDataForChallenge(
                            widget.mode, widget.currentIndex, 0);
                        Navigator.of(context).pop();
                        if (provider.mode == CcConfig.GAME_MODE__FLAG ||
                            provider.mode == CcConfig.GAME_MODE__MAP) {
                          Navigator.pushNamed(
                              context, RoutePaths.challengeGameByImage,
                              arguments: [widget.guessList, provider.mode]);
                        } else {
                          Navigator.pushNamed(
                              context, RoutePaths.challengeGameByText,
                              arguments: [widget.guessList, provider.mode]);
                        }
                      }),
                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      height: 60,
                      image: AssetsImages.challengeButton,
                      text: CcConstants.kGiveUp,
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        userProvider.updateUserDataForChallenge(
                            widget.mode, widget.currentIndex, 0);
                        Navigator.pop(context);
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
