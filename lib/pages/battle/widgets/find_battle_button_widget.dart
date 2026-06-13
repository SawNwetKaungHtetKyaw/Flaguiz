import 'package:flaguiz/bot/bot_factory.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/battle_question_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindBattleButtonWidget extends StatelessWidget {
  const FindBattleButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CountryProvider, UserProvider>(
      builder: (context, countryProvider, userProvider, child) {
        final UserModel? user = userProvider.user;
        return CcImageButton(
          margin: const EdgeInsets.only(top: 40),
          width: 250,
          height: 70,
          image: AssetsImages.battleFind,
          boxFit: BoxFit.contain,
          onTap: () async {
            AudioService.instance.playSound('tap');

            if (!await Utils.hasInternet()) {
              if (!context.mounted) return;
              Utils.showToastMessage(context, "No Internet Connection");
              return;
            }

            if (!context.mounted) return;
            Utils.showLoadingDialog(context);

            /// Load Ads
            AdsService.instance.loadInterstitialAds(
              CcAdsKey.interstitialBattleAds,
            );

            /// Generate Battle User Bot Data
            MiniProfileModel userBot = await BotFactory().createMiniProfile(
              user,
            );

            /// Generate Bot
            MiniProfileModel bot = await BotFactory().createBot();
            bot.trophy = Utils.botTrophy(userBot.trophy ?? 0);

            /// Generate Battle Question List
            List<BattleQuestionModel> temp = BattleQuestionService()
                .generateBattleList(
                  countryProvider.countryList,
                  Utils.battleDifficultyByTrophy(userBot.trophy ?? 0),
                );

            await Future.delayed(Duration(seconds: 2));

            if (!context.mounted) return;
            Utils.hideLoadingDialog(context);
            Navigator.of(context).pushNamed(
              RoutePaths.battleIntro,
              arguments: [
                temp,
                userBot,
                bot,
                Utils.botDifficultyByTrophy(userBot.trophy ?? 0),
              ],
            );
          },
        );
      },
    );
  }
}
