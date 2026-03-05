import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/home/dialog/daily_reward_dialog.dart';
import 'package:flaguiz/pages/home/provider/home_provider.dart';
import 'package:flaguiz/pages/home/widgets/home_game_button_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_game_mode_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_profile_widget.dart';
import 'package:flaguiz/pages/home/widgets/home_setting_widget.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_coin_box_widget.dart';
import 'package:flaguiz/widgets/cc_energy_box_widget.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AudioService.instance.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AudioService.instance.stopMusic();
    } else if (state == AppLifecycleState.resumed) {
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
    return ChangeNotifierProvider<HomeProvider>(
      create: (context) => HomeProvider(),
      builder: (context, child) =>
          Consumer3<HomeProvider, UserProvider, BackgroundProvider>(builder:
              (context, provider, userProvider, backgroundProvider, child) {
        UserModel? user = userProvider.user;
        backgroundProvider.getById(user?.backgrounds?[0] ?? '');
        return Scaffold(
            body: Stack(
          children: [
            // const rive.RiveAnimation.asset(
            //   'assets/animation/test.riv',
            //   fit: BoxFit.cover,
            // ),
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${CcConfig.image_base_url}${backgroundProvider.background?.imageUrl}"),
                      fit: BoxFit.cover)),
            ),

            /// Daily Reward
            Positioned(
              top: 200,
              left: 10,
              child: GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (context) => const DailyRewardDialog(),);
              },
              child: Container(
                width: 80,height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(AssetsImages.dailyReward))
                ),
              ),
            ) ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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

                    /*
                          Game Mode Section
                          */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Previous Button
                        IconButton(
                            onPressed: () {
                              provider.previous();
                              _controller.animateToPage(provider.currentIndex);
                            },
                            icon: Image.asset(AssetsImages.leftMoveButton,
                                width: 20)),

                        /// Game Mode Text
                        HomeGameModeWidget(
                          controller: _controller,
                        ),

                        /// Next Button
                        IconButton(
                            onPressed: () {
                              provider.next();
                              _controller.animateToPage(provider.currentIndex);
                            },
                            icon: Image.asset(AssetsImages.rightMoveButton,
                                width: 20)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /*
                          Home Page Button Section
                          */
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
                                      gameModeBackground[provider.currentIndex],
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
                            Navigator.of(context).pushNamed(RoutePaths.library);
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
        ));
      }),
    );
  }
}
