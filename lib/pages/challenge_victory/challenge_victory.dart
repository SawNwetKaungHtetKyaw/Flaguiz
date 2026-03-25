import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/challenge_victory/widgets/challenge_victory_icon_button_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_point_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeVictory extends StatefulWidget {
  const ChallengeVictory(
      {super.key,
      required this.mode,
      required this.life,
      required this.currentIndex,
      required this.isReplay});
  final String mode;
  final int life;
  final int currentIndex;
  final bool isReplay;

  @override
  State<ChallengeVictory> createState() => _ChallengeVictoryState();
}

class _ChallengeVictoryState extends State<ChallengeVictory> {
  int coin = 200;
  int doubleCoin = 0;
  @override
  void initState() {
    super.initState();
    coin = widget.isReplay ? 50 : 200;
    doubleCoin = widget.isReplay ? 100 : 400;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.updateUserDataForChallenge(
        widget.mode, widget.currentIndex, coin);
    AudioService.instance.startSoundTrack(AssetAudios.challengeWinSound);
    showAchievementDialog(userProvider);
  }

  showAchievementDialog(UserProvider provider) {
    UserModel? user = provider.user;

    List<ChallengeCompletedModel> temp = user?.challengeCompletedList ?? [];

    bool hasComplete = temp.every((item) => item.complete == "233");

    bool hasAchv = user?.achievements!.contains('ACHV_002') ?? false;
    if (hasComplete && !hasAchv) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.updateUserDataForAchievement(
            "ACHV_002", CcConfig.ACHIEVEMENT_COIN);
        showDialog(
            context: context,
            builder: (context) => const CcAchievementDialog(
                achievementId: "ACHV_002", showDescription: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer2<UserProvider, CountryProvider>(
          builder: (context, userProvider, countryProvider, child) {
        List<CountryModel> countries = countryProvider.countryList;

        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.challengeBg),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              width: size.width,
              margin: const EdgeInsets.only(bottom: 80),
              padding: EdgeInsets.symmetric(horizontal: size.width / 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssetsImages.challengeYouWin))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  /// You Win
                  const CcShadowedTextWidget(
                      text: CcConstants.kYouWin, fontSize: 34, dx: 5, dy: 5),
                  const SizedBox(height: 15),

                  /// Point Widget
                  CcPointWidget(point: widget.life.toString(), iconSize: 50),

                  const SizedBox(height: 15),

                  /// Coin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsImages.coin, width: 30),
                      const SizedBox(width: 5),
                      CcShadowedTextWidget(text: "+$coin coins", fontSize: 14),
                    ],
                  ),

                  const SizedBox(height: 15),

                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      image: AssetsImages.challengeButton,
                      text: (doubleCoin != coin)
                          ? CcConstants.kDoubleReward
                          : CcConstants.kClaimed,
                      height: 60,
                      onTap: () {
                        if (AdsService.instance
                                .isReady(CcAdsKey.rewardDouble) &&
                            doubleCoin != coin) {
                          AdsService.instance
                              .show(CcAdsKey.rewardDouble, context, () async {
                            AudioService.instance.playSound('claim');

                            await userProvider.addUserCoin(coin);
                            setState(() {
                              coin = coin * 2;
                            });
                          });
                        } else {
                          Utils.showToastMessage(context, CcConstants.kUnavailableNow);
                        }
                      }),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        /// Re-Play
                        ChallengeVictoryIconButtonWidget(
                            icon: Icons.refresh,
                            onTap: () {
                              AudioService.instance.playSound('tap');
                              if (widget.mode == CcConfig.GAME_MODE__FLAG ||
                                  widget.mode == CcConfig.GAME_MODE__MAP) {
                                Navigator.pushReplacementNamed(
                                    context, RoutePaths.challengeGameByImage,
                                    arguments: [
                                      Utils.prepareChallengeGameModeData(
                                          countries),
                                      widget.mode
                                    ]);
                              } else {
                                Navigator.pushReplacementNamed(context,
                                    RoutePaths.challengeGameByText, arguments: [
                                  Utils.prepareChallengeGameModeData(countries),
                                  widget.mode
                                ]);
                              }
                            }),

                        const SizedBox(width: 20),

                        /// Menu
                        ChallengeVictoryIconButtonWidget(
                            icon: Icons.menu,
                            onTap: () async {
                              AudioService.instance.playSound('tap');
                              Navigator.pop(context);
                              AudioService.instance.allowMusic = true;
                              await AudioService.instance.resume();
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
