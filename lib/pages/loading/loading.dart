import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/loading/widgets/loading_bar_widget.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/daily_reward_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/repositories/avatar_repository.dart';
import 'package:flaguiz/repositories/background_repository.dart';
import 'package:flaguiz/repositories/banner_repository.dart';
import 'package:flaguiz/repositories/border_repository.dart';
import 'package:flaguiz/service/billing_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.checkUpdate(context);
    });
    AvatarRepository().startSync();
    BorderRepository().startSync();
    BackgroundRepository().startSync();
    BannerRepository().startSync();
    DailyRewardProvider provider = Provider.of<DailyRewardProvider>(
      context,
      listen: false,
    );
    provider.initReward();
    _preloadingForHome();
  }

  void _preloadingForHome() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    BackgroundProvider backgroundProvider = Provider.of<BackgroundProvider>(
      context,
      listen: false,
    );
    await userProvider.initUser();
    userProvider.syncLocalToFirestoreIfNeeded();
    await BillingService().checkAndExpirePremium(userProvider);
    UserModel? user = userProvider.user;
    backgroundProvider.getById(user?.backgrounds?[0] ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        CachedNetworkImageProvider(
          "${backgroundProvider.background?.imageUrl}",
        ),
        context,
      );
    });
  }

  @override
  void didChangeDependencies() async {
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
            image: AssetImage(AssetsImages.loadingBg),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Spacer(), LoadingBarWidget()],
        ),
      ),
    );
  }
}
