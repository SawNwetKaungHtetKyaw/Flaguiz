import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/battle/widgets/find_battle_button_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_ads_banner_widget.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Battle extends StatefulWidget {
  const Battle({super.key});

  @override
  State<Battle> createState() => _BattleState();
}

class _BattleState extends State<Battle> {
  @override
  void initState() {
    super.initState();
    AudioService.instance.playMusic(MusicType.battle);
  }

  @override
  void dispose() {
    AudioService.instance.playMusic(MusicType.home);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final UserModel? user = userProvider.user;
        return Scaffold(
          body: Stack(
            children: [
              Hero(
                tag: CcConstants.kH_GAME_MODE,
                child: SizedBox.expand(
                  child: Image.asset(AssetsImages.battleBg, fit: BoxFit.cover),
                ),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: CcBackWidget(
                        image: AssetsImages.battleBackKey,
                        margin: EdgeInsets.all(8),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),

                        /// Battle Iconic
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(AssetsImages.battle, width: 150),
                        ),

                        const SizedBox(height: 10),

                        const CcShadowedTextWidget(
                          text: CcConstants.kBattle,
                          fontSize: 28,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AssetsImages.trophy, width: 50),
                            CcShadowedTextWidget(
                              text: (user?.trophy ?? 0).toString(),
                              fontSize: 16,
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CcImageButton(
                                    width: 70,
                                    height: 70,
                                    boxFit: BoxFit.contain,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    image: AssetsImages.battleChallenge,
                                    onTap: () async {
                                      AudioService.instance.playSound('tap');
                                      if (!await Utils.hasInternet()) {
                                        if (!context.mounted) return;
                                        Utils.showToastMessage(
                                          context,
                                          "No Internet Connection",
                                        );
                                        return;
                                      }
                                      if (!context.mounted) return;
                                      Navigator.of(
                                        context,
                                      ).pushNamed(RoutePaths.battleChallenge);
                                    },
                                  ),
                                  const CcShadowedTextWidget(
                                    text: CcConstants.kBattleChallenge,
                                    letterSpacing: 1,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CcImageButton(
                                    width: 70,
                                    height: 70,
                                    boxFit: BoxFit.contain,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    image: AssetsImages.battleLeaderboard,
                                    alignment: Alignment.bottomCenter,
                                    onTap: () {
                                      AudioService.instance.playSound('tap');
                                      Navigator.of(
                                        context,
                                      ).pushNamed(RoutePaths.leaderboard);
                                    },
                                  ),
                                  const CcShadowedTextWidget(
                                    text: CcConstants.kBattleLeaderboard,
                                    letterSpacing: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const FindBattleButtonWidget(),

                        const Spacer(),

                        const CcAdsBannerWidget(adKey: CcAdsKey.bannerLibrary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
