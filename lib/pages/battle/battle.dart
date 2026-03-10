import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class Battle extends StatefulWidget {
  const Battle({super.key});

  @override
  State<Battle> createState() => _BattleState();
}

class _BattleState extends State<Battle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: CcConstants.kH_GAME_MODE,
            child: SizedBox.expand(
              child: Image.asset(
                AssetsImages.battleBg,
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
                      image: AssetsImages.defaultBackKey,
                      margin: EdgeInsets.all(8)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    /// Battle Iconic
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset(AssetsImages.battle, width: 200)),

                    const SizedBox(height: 10),

                    const CcShadowedTextWidget(
                      text: CcConstants.kBattle,
                      fontSize: 28,
                    ),


                    CcOutlinedButton(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: 150,
                      color: successColor,
                        child: const CcShadowedTextWidget(
                            text: CcConstants.kFindBattle),
                        onTap: () {
                          AudioService.instance.playSound('tap');
                          Utils.showToastMessage(
                              context, CcConstants.kComingSoon);
                        })
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
