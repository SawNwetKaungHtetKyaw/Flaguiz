import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/challenge/widgets/challenge_game_type_widget.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_ads_banner_widget.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AudioService.instance.playMusic(MusicType.challenge);
  }

  @override
  void dispose() {
    AudioService.instance.playMusic(MusicType.home);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: CcConstants.kH_GAME_MODE,
            child: SizedBox.expand(
              child: Image.asset(
                AssetsImages.challengeBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: CcBackWidget(
                      image: AssetsImages.challengeBackKey,
                      margin: EdgeInsets.all(8)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    /// Challenge Iconic
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset(AssetsImages.challenge, width: 230)),

                    /// Challenge Title
                    const Center(
                        child: CcShadowedTextWidget(
                      text: CcConstants.kChallenge,
                      fontSize: 28,
                    )),

                    /// Game Type ListView
                    const ChallengeGameTypeWidget(),

                    /// Banner Ads
                     const Center(child: CcAdsBannerWidget(adKey: CcAdsKey.bannerChallenge))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
