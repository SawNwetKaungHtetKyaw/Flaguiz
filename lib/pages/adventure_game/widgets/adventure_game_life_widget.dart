import 'package:flaguiz/pages/adventure_game/provider/adventure_game_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureGameLifeWidget extends StatelessWidget {
  const AdventureGameLifeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AdventureGameProvider, int>(
      selector: (context, provider) => provider.remainingLife,
      builder: (context, remainingLife, child) => Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.adventureButton),
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
