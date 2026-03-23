import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/daily_reward_model.dart';
import 'package:flaguiz/providers/daily_reward_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyRewardDialog extends StatelessWidget {
  const DailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DailyRewardProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        final DailyRewardModel? reward = provider.reward;

        bool canClaim = provider.canClaim;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: 560,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.only(
                    top: 100, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(color: Colors.white, width: 3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 110,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        int day = index + 1;
                        // bool isClaimed =(reward?.lastClaimDate == null) ? day <= (reward?.currentDay ?? 0) && !provider.canClaim : day <= (reward?.currentDay ?? 0);
                        bool isClaimed = day <= (reward?.currentDay ?? 0);
                        return DailyRewadCardWidget(
                            isClaimed: isClaimed,
                            canClaim: canClaim,
                            dayIndex: day,
                            currentDay: reward?.currentDay ?? 0,
                            claimRewardIndex: index);
                      },
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.5),
                            child: DailyRewadCardWidget(
                                isClaimed: 7 <= (reward?.currentDay ?? 0),
                                canClaim: canClaim,
                                dayIndex: 7,
                                currentDay: reward?.currentDay ?? 0,
                                claimRewardIndex: 6),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    canClaim
                        ? Row(
                            children: [
                              Expanded(
                                child: CcOutlinedButton(
                                    height: 60,
                                    color:
                                        canClaim ? primaryColor : Colors.grey,
                                    child: const CcShadowedTextWidget(
                                        text: CcConstants.kClaim),
                                    onTap: () async {
                                      if (canClaim) {
                                        AudioService.instance
                                            .playSound('claim');
                                        int coins = await provider.claim();
                                        if (coins > 0) {
                                          await userProvider.addUserCoin(coins);
                                        }
                                      }
                                    }),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CcOutlinedButton(
                                    height: 60,
                                    color:
                                        canClaim ? primaryColor : Colors.grey,
                                    child: const CcShadowedTextWidget(
                                        text: CcConstants.kClaim2x),
                                    onTap: () async {
                                      if (canClaim) {
                                        if (AdsService.instance
                                            .isReady(CcAdsKey.rewardDouble)) {
                                          AudioService.instance
                                              .playSound('claim');
                                          AdsService.instance.show(
                                              CcAdsKey.rewardDouble, context,
                                              () async {
                                            int coins = await provider.claim();
                                            if (coins > 0) {
                                              coins = coins * 2;
                                              await userProvider
                                                  .addUserCoin(coins);
                                            }
                                          });
                                        } else {
                                          Utils.showToastMessage(
                                              context, "Try Again");
                                        }
                                      }
                                    }),
                              )
                            ],
                          )
                        : CcOutlinedButton(
                            height: 60,
                            child: const CcShadowedTextWidget(
                                text: CcConstants.kClose),
                            onTap: () async {
                              AudioService.instance.playSound('back');
                              Navigator.of(context).pop();
                            }),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 90,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    boxShadow: [BoxShadow(offset: Offset(0, 5))]),
                child: Stack(
                  children: [
                    const Center(
                        child: CcShadowedTextWidget(
                            text: CcConstants.kDailyReward, fontSize: 18)),
                    Positioned(
                        top: 2,
                        right: 2,
                        child: IconButton(
                            onPressed: () {
                              AudioService.instance.playSound('back');
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 30)))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class DailyRewadCardWidget extends StatelessWidget {
  const DailyRewadCardWidget(
      {super.key,
      required this.isClaimed,
      required this.canClaim,
      required this.dayIndex,
      required this.currentDay,
      required this.claimRewardIndex});

  final bool isClaimed;
  final bool canClaim;
  final int dayIndex;
  final int claimRewardIndex;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    List<String> dailyRewardImages = [
      AssetsImages.coin1,
      AssetsImages.coin1,
      AssetsImages.coin2,
      AssetsImages.coin2,
      AssetsImages.coin3,
      AssetsImages.coin3,
      AssetsImages.coin4,
    ];

    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          height: 110,
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white, width: 3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CcShadowedTextWidget(text: "Day $dayIndex", dx: 1.5, dy: 1.5),
              const SizedBox(height: 5),
              Image.asset(dailyRewardImages[claimRewardIndex],
                  width: 45, height: 45),
              const SizedBox(height: 8),
              CcShadowedTextWidget(
                  text: "${CcConfig.dailyRewardItems[claimRewardIndex]} COINS",
                  fontSize: 10,
                  letterSpacing: 1,
                  dx: 1,
                  dy: 1),
            ],
          ),
        ),
        Visibility(
          visible: isClaimed,
          child: Container(
            width: double.maxFinite,
            height: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.5)),
            child: Icon(
              Icons.done_outline,
              color: Colors.green.shade700,
              size: 60,
            ),
          ),
        )
      ],
    );
  }
}
