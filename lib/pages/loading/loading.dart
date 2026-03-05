import 'package:flaguiz/pages/loading/widgets/loading_bar_widget.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/providers/daily_reward_provider.dart';
import 'package:flaguiz/repositories/avatar_repository.dart';
import 'package:flaguiz/repositories/background_repository.dart';
import 'package:flaguiz/repositories/banner_repository.dart';
import 'package:flaguiz/repositories/border_repository.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    AvatarRepository().startSync();
    BorderRepository().startSync();
    BackgroundRepository().startSync();
    BannerRepository().startSync();
    DailyRewardProvider provider = Provider.of<DailyRewardProvider>(context,listen: false);
    provider.initReward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AchievementProvider>(context).loadAchvList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.loadingBg), fit: BoxFit.cover)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Spacer(), LoadingBarWidget()],
        ),
      ),
    );
  }
}
