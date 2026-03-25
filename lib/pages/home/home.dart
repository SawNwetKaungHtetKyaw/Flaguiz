import 'package:carousel_slider/carousel_controller.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/home/dialog/daily_reward_dialog.dart';
import 'package:flaguiz/pages/home/dialog/exit_dialog.dart';
import 'package:flaguiz/pages/home/provider/home_provider.dart';
import 'package:flaguiz/pages/home/widgets/home_game_button_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_game_mode_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_profile_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_setting_widget.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_coin_box_widget.dart';
import 'package:flaguiz/widgets/cc_energy_box_widget.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rive/rive.dart' as rive;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final CarouselSliderController _controller = CarouselSliderController();
  final List<String> gameModeBackground = [
    AssetsImages.adventureBg,
    AssetsImages.challengeBg,
    AssetsImages.battleBg
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    AudioService.instance.init();
    VibrationService.instance.init();
    AdsService.instance.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AudioService.instance.stopMusic();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.instance.allowMusic = true;
      AudioService.instance.resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AudioService audioService = AudioService.instance;
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      builder: (context, child) =>
          Consumer3<HomeProvider, UserProvider, BackgroundProvider>(builder:
              (context, provider, userProvider, backgroundProvider, child) {
        UserModel? user = userProvider.user;
        String? backgroundURL =
            (backgroundProvider.background?.imageUrl == null)
                ? CcConfig.default_background
                : backgroundProvider.background?.imageUrl;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              showDialog(
                  context: context, builder: (context) => const ExitDialog());
            }
          },
          child: Scaffold(
              body: Stack(
            children: [
              // const rive.RiveAnimation.asset(
              //   'assets/animation/test.riv',
              //   fit: BoxFit.cover,
              // ),

              CcNetworkImageWidget(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  imageUrl: "${CcConfig.image_base_url}$backgroundURL"),

              /// Friends
              Positioned(
                  top: 200,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      audioService.playSound('tap');
                      Utils.showToastMessage(context, CcConstants.kComingSoon);
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AssetsImages.friends)),
                      ),
                    ),
                  )),

              /// Premium
              Positioned(
                  top: 195,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      audioService.playSound("tap");
                      Utils.showToastMessage(context, CcConstants.kComingSoon);
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AssetsImages.premium)),
                      ),
                    ),
                  )),

              /// Daily Reward
              Positioned(
                  top: 300,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Utils.preLoadRewardedAds(CcAdsKey.rewardDouble);
                      audioService.playSound("tap");
                      showDialog(
                        context: context,
                        builder: (context) => const DailyRewardDialog(),
                      );
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AssetsImages.dailyReward))),
                    ),
                  )),

              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Home Profile View
                          HomeProfileWidget(
                            avatarId: user?.avatars?[0] ?? 'AVT_001',
                            borderId: user?.borders?[0] ?? 'BD_001',
                          ),

                          /// Energy Box
                          CcEnergyBoxWidget(
                              energy: user?.energy.toString() ?? '0'),

                          /// Coin Box
                          CcCoinBoxWidget(coin: user?.coin.toString() ?? '0'),

                          /// Home Profile View
                          const HomeSettingWidget(),
                        ],
                      ),
                      const Spacer(),

                      //// Game Mode Section(  <-   MODE   ->)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Previous Button
                          IconButton(
                              onPressed: () async {
                                audioService.playSound('tap');
                                provider.previous();
                                _controller
                                    .animateToPage(provider.currentIndex);
                              },
                              icon: Image.asset(AssetsImages.leftMoveButton,
                                  width: 20)),

                          /// Game Mode Text
                          HomeGameModeWidget(
                            controller: _controller,
                          ),

                          /// Next Button
                          IconButton(
                              onPressed: () async {
                                audioService.playSound('tap');
                                provider.next();
                                _controller
                                    .animateToPage(provider.currentIndex);
                              },
                              icon: Image.asset(AssetsImages.rightMoveButton,
                                  width: 20)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      /// Home Button (SHOP | ENTER | LIBRARY)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Shop Button
                          HomeGameButtonWidget(
                            width: 100,
                            height: 70,
                            margin: const EdgeInsets.only(bottom: 8),
                            backgroundImage: AssetsImages.shopButton,
                            onTap: () {
                              Navigator.of(context).pushNamed(RoutePaths.shop);
                            },
                          ),

                          /// Play Game Button
                          Stack(
                            children: [
                              Positioned(
                                bottom: 30,
                                right: 32,
                                child: Hero(
                                  tag: CcConstants.kH_GAME_MODE,
                                  child: SizedBox(
                                      width: 76,
                                      height: 92,
                                      child: Image.asset(
                                        gameModeBackground[
                                            provider.currentIndex],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              HomeGameButtonWidget(
                                onTap: () {
                                  if (provider.currentIndex == 0) {
                                    Navigator.of(context)
                                        .pushNamed(RoutePaths.adventure);
                                  } else if (provider.currentIndex == 1) {
                                    Navigator.of(context)
                                        .pushNamed(RoutePaths.challenge);
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(RoutePaths.battle);
                                  }
                                },
                              ),
                            ],
                          ),

                          /// Library Button
                          HomeGameButtonWidget(
                            width: 100,
                            height: 70,
                            margin: const EdgeInsets.only(bottom: 8),
                            backgroundImage: AssetsImages.libraryButton,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RoutePaths.library);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ],
          )),
        );
      }),
    );
  }
}
