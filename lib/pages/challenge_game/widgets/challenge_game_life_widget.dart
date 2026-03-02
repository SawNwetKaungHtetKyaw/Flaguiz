import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameLifeWidget extends StatelessWidget {
  const ChallengeGameLifeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ChallengeGameProvider, int>(
      selector: (context, provider) => provider.remainingLife,
      builder: (context, remainingLife, child) => Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.challengeButton),
                fit: BoxFit.fill)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CcShadowedIconWidget(
                color: (remainingLife >= 1) ? Colors.red : Colors.white),
            CcShadowedIconWidget(
                color: (remainingLife >= 2) ? Colors.red : Colors.white),
            CcShadowedIconWidget(
                color: (remainingLife >= 3) ? Colors.red : Colors.white),
          ],
        ),
      ),
    );
  }
}
