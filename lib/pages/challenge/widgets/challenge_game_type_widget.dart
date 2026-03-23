import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameTypeWidget extends StatefulWidget {
  const ChallengeGameTypeWidget({super.key});

  @override
  State<ChallengeGameTypeWidget> createState() =>
      _ChallengeGameTypeWidgetState();
}

class _ChallengeGameTypeWidgetState extends State<ChallengeGameTypeWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _offsetAnimations;
  late List<Animation<double>> _opacityAnimations;

  final int itemCount = 4;
  final List<String> gameType = ['Flag', 'Country', 'Map', 'Capital'];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _offsetAnimations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(-1.5, 0), // from left side
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            )))
        .toList();

    _opacityAnimations = _controllers
        .map((controller) => Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeIn,
            )))
        .toList();

    // Start animations one by one
    _startSequentialAnimations();
  }

  Future<void> _startSequentialAnimations() async {
    for (int i = 0; i < itemCount; i++) {
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CountryProvider, UserProvider>(
        builder: (context, countryProvider, userProvider, child) {
      List<CountryModel> countries = countryProvider.countryList;
      List<ChallengeCompletedModel> temp =
          userProvider.user?.challengeCompletedList ?? [];

      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            String mode = Utils.retureGameMode(index);
            ChallengeCompletedModel completedChallenge =
                temp.firstWhere((c) => c.mode == mode);
            return SlideTransition(
              position: _offsetAnimations[index],
              child: FadeTransition(
                  opacity: _opacityAnimations[index],
                  child: Stack(
                    children: [
                      CcImageButton(
                        image: AssetsImages.challengeButton,
                        text: gameType[index],
                        onTap: () {
                          
                          Utils.preLoadRewardedAds(CcAdsKey.rewardDouble);
                          Utils.preLoadRewardedAds(CcAdsKey.rewardContinueGame);

                          AudioService.instance.playSound('tap');
                          if (mode == CcConfig.GAME_MODE__FLAG ||
                              mode == CcConfig.GAME_MODE__MAP) {
                            Navigator.pushNamed(
                                context, RoutePaths.challengeGameByImage,
                                arguments: [
                                  Utils.prepareChallengeGameModeData(countries),
                                  mode
                                ]);
                          } else {
                            Navigator.pushNamed(
                                context, RoutePaths.challengeGameByText,
                                arguments: [
                                  Utils.prepareChallengeGameModeData(countries),
                                  mode
                                ]);
                          }
                        },
                      ),
                      Positioned(
                          bottom: 25,
                          right: 30,
                          child: CcShadowedTextWidget(
                            text:
                                "${completedChallenge.complete}/${countries.length}",
                            fontSize: 10,
                            textColor: Colors.grey.shade300,
                          ))
                    ],
                  )),
            );
          },
        ),
      );
    });
  }
}
