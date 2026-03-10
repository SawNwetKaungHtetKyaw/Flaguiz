import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/adventure/provider/adventure_provider.dart';
import 'package:flaguiz/pages/adventure_victory/widgets/adventure_victory_icon_button_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_point_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureVictory extends StatefulWidget {
  const AdventureVictory(
      {super.key,
      required this.mode,
      required this.levelId,
      required this.life,
      required this.guessList,
      required this.isReplay});
  final String mode;
  final String levelId;
  final int life;
  final List<GuessModel> guessList;
  final bool isReplay;

  @override
  State<AdventureVictory> createState() => _AdventureVictoryState();
}

class _AdventureVictoryState extends State<AdventureVictory> {
  int coin = 20;
  int index = -1;
  @override
  void initState() {
    super.initState();
    coin = widget.isReplay ? 5 : 20;

    AudioService.instance.startSoundTrack(AssetAudios.adventureWinSound);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    AdventureProvider adventureProvider =
        Provider.of<AdventureProvider>(context, listen: false);
    userProvider.updateUserDataForAdventure(widget.levelId, widget.life, coin);
    userProvider.updateUserDataForNextAdventureLevel(
        nextLevelId(adventureProvider.levelList));

    showAchievementDialog(userProvider);
  }

  showAchievementDialog(UserProvider provider) {
    UserModel? user = provider.user;

    bool hasAchv = user?.achievements!.contains('ACHV_001') ?? false;
    int length =
        user?.adventureCompletedList?.where((c) => c.life != "0").length ?? 0;
    if (length == 92 && !hasAchv) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.updateUserDataForAchievement(
            "ACHV_001", CcConfig.ACHIEVEMENT_COIN);
        showDialog(
            context: context,
            builder: (context) => const CcAchievementDialog(
                achievementId: 'ACHV_001', showDescription: false));
      });
    }
  }

  String nextLevelId(List<AdventureModel> adventureLevelList) {
    index = nextLevelIndex(adventureLevelList);
    String nextLevelId = '';
    if (index != -1) {
      nextLevelId =
          "${widget.mode}_${(adventureLevelList[index].level ?? "0").padLeft(2, '0')}";
    }

    return nextLevelId;
  }

  int nextLevelIndex(List<AdventureModel> list) {
    final lastTwo = widget.levelId.substring(widget.levelId.length - 2);

    final normalizedValue = (int.parse(lastTwo) + 1).toString();

    final index = list.indexWhere((e) => e.level == normalizedValue);

    return index;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer3<UserProvider, CountryProvider, AdventureProvider>(builder:
          (context, userProvider, countryProvider, adventureProvider, child) {
        List<CountryModel> countries = countryProvider.countryList;
        List<AdventureModel> adventureLevelList = adventureProvider.levelList;

        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.adventureBg),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width / 12),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssetsImages.adventureYouWin))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// You Win
                  const CcShadowedTextWidget(
                      text: CcConstants.kYouWin, fontSize: 30, dx: 5, dy: 5),
                  const SizedBox(height: 15),

                  /// Point Widget
                  CcPointWidget(point: widget.life.toString(), iconSize: 50),

                  const SizedBox(height: 15),

                  /// Coin
                  CcShadowedTextWidget(text: "$coin coins", fontSize: 14),

                  const SizedBox(height: 15),

                  CcImageButton(
                      margin: const EdgeInsets.only(
                          bottom: 10, right: 20, left: 20),
                      image: AssetsImages.adventureButton,
                      text: CcConstants.kDoubleReward,
                      height: 60,
                      onTap: () {
                        Utils.showToastMessage(
                            context, CcConstants.kUnavailableNow);
                        VibrationService.instance.light();
                      }),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        /// Re-Play
                        VictoryIconButtonWidget(
                            icon: Icons.refresh,
                            onTap: () {
                              AudioService.instance.playSound('tap');
                              if (widget.mode == CcConfig.GAME_MODE__FLAG ||
                                  widget.mode == CcConfig.GAME_MODE__MAP) {
                                Navigator.pushReplacementNamed(
                                    context, RoutePaths.adventureGameByImage,
                                    arguments: [
                                      widget.guessList,
                                      widget.mode,
                                      widget.levelId
                                    ]);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, RoutePaths.adventureGameByText,
                                    arguments: [
                                      widget.guessList,
                                      widget.mode,
                                      widget.levelId
                                    ]);
                              }
                            }),

                        const SizedBox(width: 20),

                        /// Menu
                        VictoryIconButtonWidget(
                            icon: Icons.menu,
                            onTap: () async {
                              AudioService.instance.playSound('tap');
                              Navigator.pop(context);
                              await AudioService.instance.resume();
                            }),

                        const SizedBox(width: 20),

                        /// Next Level
                        (index == -1)
                            ? const SizedBox()
                            : VictoryIconButtonWidget(
                                icon: Icons.skip_next,
                                onTap: () {
                                  AudioService.instance.playSound('tap');
                                  if (widget.mode == CcConfig.GAME_MODE__FLAG ||
                                      widget.mode == CcConfig.GAME_MODE__MAP) {
                                    Navigator.pushReplacementNamed(context,
                                        RoutePaths.adventureGameByImage,
                                        arguments: [
                                          Utils.prepareAdventureGameModeData(
                                              adventureLevelList[index],
                                              countries),
                                          widget.mode,
                                          nextLevelId(adventureLevelList)
                                        ]);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, RoutePaths.adventureGameByText,
                                        arguments: [
                                          Utils.prepareAdventureGameModeData(
                                              adventureLevelList[index],
                                              countries),
                                          widget.mode,
                                          nextLevelId(adventureLevelList)
                                        ]);
                                  }
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
