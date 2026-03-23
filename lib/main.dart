import 'package:firebase_core/firebase_core.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/adventure/provider/adventure_provider.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/providers/ads_provider.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/daily_reward_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/route/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// Firebase
  await Firebase.initializeApp();

  /// Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChallengeCompletedModelAdapter());
  Hive.registerAdapter(AdventureCompletedModelAdapter());
  Hive.registerAdapter(CountryModelAdapter());
  Hive.registerAdapter(ShopModelAdapter());

  await Hive.openBox<UserModel>(CcConfig.HIVE_USER_BOX);
  await Hive.openBox<ShopModel>(CcConfig.HIVE_AVATAR_BOX);
  await Hive.openBox<ShopModel>(CcConfig.HIVE_BORDER_BOX);
  await Hive.openBox<ShopModel>(CcConfig.HIVE_BACKGROUND_BOX);
  await Hive.openBox<ShopModel>(CcConfig.HIVE_BANNER_BOX);

  CcConfig.showLog = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryProvider>(
            create: (BuildContext context) =>
                CountryProvider(buildContext: context)),
        ChangeNotifierProvider<UserProvider>(
            create: (BuildContext context) =>
                UserProvider(buildContext: context)),
        ChangeNotifierProvider<AdventureProvider>(
            create: (BuildContext context) =>
                AdventureProvider(buildContext: context)),
        ChangeNotifierProvider<AchievementProvider>(
            create: (BuildContext context) =>
                AchievementProvider(buildContext: context)),
        ChangeNotifierProvider<AvatarProvider>(
            create: (BuildContext context) =>
                AvatarProvider(buildContext: context)),
        ChangeNotifierProvider<BorderProvider>(
            create: (BuildContext context) =>
                BorderProvider(buildContext: context)),
        ChangeNotifierProvider<BackgroundProvider>(
            create: (BuildContext context) =>
                BackgroundProvider(buildContext: context)),
        ChangeNotifierProvider<BannerProvider>(
            create: (BuildContext context) =>
                BannerProvider(buildContext: context)),
        ChangeNotifierProvider(
            create: (_) => DailyRewardProvider(buildContext: context)),
        ChangeNotifierProvider(
            create: (_) => AdsProvider(buildContext: context)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SupplyCenter',
        ),
        title: 'Flaguiz',
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
