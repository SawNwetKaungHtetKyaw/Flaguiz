import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_country_widget.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_global_widget.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_local_widget.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_tab_widget.dart';
import 'package:flaguiz/providers/leaderboard_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LeaderboardProvider>(
      create: (context) => LeaderboardProvider(buildContext: context),
      builder: (context, child) => Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.battleBg), fit: BoxFit.cover)),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(AssetsImages.leaderboard),
                  Material(
                    color: Colors.grey.shade900,
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(
                        color: leaderboardColor,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (index) {
                        AudioService.instance.playSound('tap');
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                        );
                      },
                      tabs: const [
                        LeaderboardTabWidget(
                            title: CcConstants.kLeaderboardLocal),
                        LeaderboardTabWidget(
                            title: CcConstants.kLeaderboardGlobal),
                        LeaderboardTabWidget(
                            title: CcConstants.kLeaderboardCountry)
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        _tabController.animateTo(index);
                      },
                      children: const [
                        LeaderboardLocalWidget(),
                        LeaderboardGlobalWidget(),
                        LeaderboardCountryWidget()
                      ],
                    ),
                  ),
                ],
              ),
              const SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Back Key
                  CcBackWidget(
                      margin: EdgeInsets.only(left: 8, top: 8),
                      image: AssetsImages.libraryBackKey),

                  /// Leaderboard
                  Center(
                      child: CcShadowedTextWidget(
                          text: CcConstants.kLeaderboard,
                          fontSize: 18,
                          letterSpacing: 1,
                          padding: EdgeInsets.only(top: 80)))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
