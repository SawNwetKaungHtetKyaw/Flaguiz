import 'package:flaguiz/animations/scale_animation.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/battle_challenge_result/widgets/battle_challenge_result_curtain_widget.dart';
import 'package:flaguiz/pages/battle_challenge_result/widgets/friend_profile_widget.dart';
import 'package:flaguiz/pages/battle_challenge_result/widgets/host_profile_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/repositories/battle_repository.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeResult extends StatefulWidget {
  const BattleChallengeResult({
    super.key,
    required this.result,
    required this.user,
    required this.bot,
    this.roomId,
  });
  final String result;
  final MiniProfileModel user;
  final MiniProfileModel bot;
  final String? roomId;

  @override
  State<BattleChallengeResult> createState() => _BattleChallengeResultState();
}

class _BattleChallengeResultState extends State<BattleChallengeResult> {
  int coin = 10;
  int trophy = 0;
  int doubleCoin = 0;

  @override
  void initState() {
    super.initState();
    AudioService.instance.allowMusic = false;
    AudioService.instance.pause();
    coin = Utils.battleCoinByResult(widget.result);
    doubleCoin = coin * 2;
    context.read<UserProvider>().updateUserDataAfterBattle(coin, trophy);

    if (widget.result == CcConstants.BATTLE_WIN) {
      AudioService.instance.playSound('bt-win');
    } else if (widget.result == CcConstants.BATTLE_LOSE) {
      AudioService.instance.playSound('bt-lose');
    } else {
      AudioService.instance.playSound('bt-lose');
    }

    if (widget.roomId != null) {
        BattleRepository().endBattle(widget.roomId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(AssetsImages.battleBg),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.8),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              /// Stage Image
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(AssetsImages.battleStage),
              ),

              ///Curtain Image
              Positioned(
                top: 0,
                child: BattleChallengeResultCurtainWidget(
                  result: widget.result,
                ),
              ),

              /// Player Profile
              Positioned(
                top: 140,
                child: HostProfileWidget(
                  user: widget.user,
                  result: widget.result,
                ),
              ),

              /// Bot Profile
              Positioned(
                top: 140,
                right: 0,
                child: FriendProfileWidget(
                  friend: widget.bot,
                  result: widget.result,
                ),
              ),

              /// Result
              Positioned(
                top: 260,
                left: width / 2 - 120,
                child: ScaleAnimation(
                  child: Container(
                    width: 240,
                    alignment: Alignment.center,
                    child: CcShadowedTextWidget(
                      text: widget.result,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),

              /// Game Data
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 350),
                    ScaleAnimation(
                      milisecond: 900,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetsImages.coin, width: 30),
                          CcShadowedTextWidget(text: " +$coin", fontSize: 14),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    ScaleAnimation(
                      milisecond: 1100,
                      child: CcImageButton(
                        width: 250,
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 5),
                        text:
                            (doubleCoin != coin)
                                ? CcConstants.kDoubleReward
                                : CcConstants.kClaimed,
                        fontsize: 10,
                        image: AssetsImages.challengeButtonHaf,
                        onTap: () {
                          AudioService.instance.playSound('tap');
                          if (AdsService.instance.isReady(
                                CcAdsKey.rewardDouble,
                              ) &&
                              doubleCoin != coin) {
                            AdsService.instance.show(
                              CcAdsKey.rewardDouble,
                              context,
                              () async {
                                AudioService.instance.playSound('claim');

                                context
                                    .read<UserProvider>()
                                    .updateUserDataAfterBattle(coin, trophy);

                                setState(() {
                                  coin = coin * 2;
                                });
                              },
                            );
                          } else {
                            Utils.showToastMessage(
                              context,
                              CcConstants.kUnavailableNow,
                            );
                          }
                        },
                      ),
                    ),
                    ScaleAnimation(
                      milisecond: 1200,
                      child: CcImageButton(
                        width: 250,
                        height: 60,
                        text: CcConstants.kExit,
                        fontsize: 10,
                        image: AssetsImages.challengeButtonHaf,
                        onTap: () {
                          context.read<UserProvider>().notifyListeners();
                          AudioService.instance.playSound('back');
                          Navigator.of(context).pop();

                          AudioService.instance.allowMusic = true;
                          AudioService.instance.resume();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Rope Image
              Image.asset(AssetsImages.battleRope),
            ],
          ),
        ),
      ),
    );
  }
}
